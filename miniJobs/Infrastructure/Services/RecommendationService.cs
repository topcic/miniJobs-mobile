using Application.Common.Interfaces;
using Domain.Enums;
using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Services;

public class RecommendationService(ApplicationDbContext context) : IRecommendationService
{
    public async Task<IEnumerable<Job>> GetRecommendationJobsAsync(int userId)
    {
        // Fetch user's job preferences
        var jobPreferences = context.JobRecommendations
     .Where(jr => jr.CreatedBy == userId)
     .Select(jr => new
     {
         JobRecommendationId = jr.Id,
         Cities = context.JobRecommendationCities
             .Where(jrc => jrc.JobRecommendationId == jr.Id)
             .Select(jrc => jrc.CityId)
             .ToList(),
         JobTypes = context.JobRecommendationJobTypes
             .Where(jrt => jrt.JobRecommendationId == jr.Id)
             .Select(jrt => jrt.JobTypeId)
             .ToList()
     })
     .FirstOrDefault();
        // Fetch all jobs where status is Active
        var activeJobs = await context.Jobs
            .Where(job => job.Status == JobStatus.Active)
            .ToListAsync();

        // Filter jobs based on preferences (if preferences exist)
        var filteredJobs = activeJobs;
        if (jobPreferences != null)
        {
            filteredJobs = activeJobs
                .Where(job =>
                    (jobPreferences.Cities.Contains(job.CityId) || jobPreferences.Cities.Count == 0) &&
                    (jobPreferences.JobTypes.Contains(job.JobTypeId ?? 0) || jobPreferences.JobTypes.Count == 0))
                .ToList();
        }

        // Exclude jobs the user has already interacted with
        var excludedJobIds = await context.JobApplications
            .Where(app =>  !app.IsDeleted && app.CreatedBy == userId)
            .Select(app => app.JobId)
            .Union(
                context.SavedJobs
                    .Where(saved => !saved.IsDeleted && saved.CreatedBy == userId)
                    .Select(saved => saved.JobId))
            .ToListAsync();

        // Include ratings to rank jobs
        // Fetch ratings for relevant jobs
        var jobRatings = await context.Ratings
            .Where(r => filteredJobs.Select(job => job.CreatedBy).Contains(r.RatedUserId) && r.IsActive)
            .GroupBy(r => r.RatedUserId)
            .Select(g => new { UserId = g.Key, AverageRating = g.Average(r => r.Value) })
            .ToListAsync();

        // Include ratings to rank jobs
        var recommendedJobs = filteredJobs
            .Where(job => !excludedJobIds.Contains(job.Id)) // Exclude interacted jobs
            .Select(job => new
            {
                Job = job,
                AverageRating = jobRatings
                    .Where(r => r.UserId == job.CreatedBy)
                    .Select(r => r.AverageRating)
                    .DefaultIfEmpty(0)
                    .First()
            })
            .OrderByDescending(job => job.AverageRating) // Rank by average rating
            .Take(6) // Limit to 6 jobs
            .Select(j => j.Job) // Return jobs only
            .ToList();

        // Return recommended jobs or fallback to active jobs if no recommendations are found
        return recommendedJobs.Any() ? recommendedJobs : activeJobs.Take(6);
    }


}