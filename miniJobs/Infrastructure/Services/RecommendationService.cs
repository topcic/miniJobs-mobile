using Application.Common.Interfaces;
using Domain.Dtos;
using Domain.Enums;
using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Services;

public class RecommendationService(ApplicationDbContext context) : IRecommendationService
{
    public async Task<IEnumerable<JobCardDTO>> GetRecommendationJobsAsync(int userId)
    {
        // 1. Fetch user's job preferences
        var jobPreferences = await context.JobRecommendations
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
            .FirstOrDefaultAsync(); // ✅ Use `FirstOrDefaultAsync()`

        // 2. Fetch all active jobs
        var activeJobs = await context.Jobs
            .Where(job => job.Status == JobStatus.Active)
            .ToListAsync();

        // 3. Filter jobs based on preferences
        var filteredJobs = jobPreferences != null
            ? activeJobs.Where(job =>
                (jobPreferences.Cities.Contains(job.CityId) || !jobPreferences.Cities.Any()) &&
                (jobPreferences.JobTypes.Contains(job.JobTypeId ?? 0) || !jobPreferences.JobTypes.Any()))
                .ToList()
            : activeJobs;

        // 4. Exclude jobs the user has interacted with
        var excludedJobIds = await context.JobApplications
            .Where(app => !app.IsDeleted && app.CreatedBy == userId)
            .Select(app => app.JobId)
            .Union(
                context.SavedJobs
                    .Where(saved => !saved.IsDeleted && saved.CreatedBy == userId)
                    .Select(saved => saved.JobId))
            .ToListAsync();

        // 5. Find similar users and their jobs
        var userJobIds = await context.JobApplications
            .Where(ua => !ua.IsDeleted && ua.CreatedBy == userId)
            .Select(ua => ua.JobId)
            .ToListAsync();

        var similarUserJobIds = await context.JobApplications
            .Where(app => !app.IsDeleted && app.CreatedBy != userId)
            .GroupBy(app => app.CreatedBy)
            .Select(g => new
            {
                UserId = g.Key,
                SharedJobs = g.Select(app => app.JobId).Intersect(userJobIds).Count()
            })
            .Where(user => user.SharedJobs > 0)
            .OrderByDescending(user => user.SharedJobs)
            .Take(10)
            .SelectMany(user =>
                context.JobApplications
                    .Where(app => app.CreatedBy == user.UserId && !app.IsDeleted)
                    .Select(app => app.JobId))
            .Distinct()
            .ToListAsync();

        // 6. Fetch job ratings
        var jobRatings = await context.Ratings
            .Where(r => filteredJobs.Select(job => job.CreatedBy).Contains(r.RatedUserId) && r.IsActive)
            .GroupBy(r => r.RatedUserId)
            .Select(g => new { UserId = g.Key, AverageRating = g.Average(r => r.Value) })
            .ToListAsync();

        // 7. Compute job scores and rank them
        var jobScores = filteredJobs
            .Where(job => !excludedJobIds.Contains(job.Id)) 
            .Select(job => new
            {
                Job = job,
                ContentScore = (jobPreferences?.Cities.Contains(job.CityId) == true ? 1 : 0) +
                               (jobPreferences?.JobTypes.Contains(job.JobTypeId ?? 0) == true ? 1 : 0),
                CollaborativeScore = similarUserJobIds.Contains(job.Id) ? 1 : 0,
                AverageRating = jobRatings.FirstOrDefault(r => r.UserId == job.CreatedBy)?.AverageRating ?? 0
            })
            .OrderByDescending(job => job.ContentScore * 0.5 + job.CollaborativeScore * 0.3 + job.AverageRating * 0.2)
            .Take(6)
            .Select(j => j.Job)
            .ToList();

        // 8. Map jobs to DTOs
        var result = jobScores
            .Select(job => new JobCardDTO
            {
                Id = job.Id,
                Name = job.Name,
                CityName = context.Cities.FirstOrDefault(c => c.Id == job.CityId)?.Name,
                Wage = job.Wage
            })
            .ToList();

        // 9. Fallback to active jobs if no recommendations
        return result.Any() ? result : activeJobs.Take(6).Select(job => new JobCardDTO
        {
            Id = job.Id,
            Name = job.Name,
            CityName = context.Cities.FirstOrDefault(c => c.Id == job.CityId)?.Name,
            Wage = job.Wage
        }).ToList();
    }



}