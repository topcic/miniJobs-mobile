using Application.Common.Interfaces;
using Domain.Enums;
using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Services;

public class RecommendationService(ApplicationDbContext context) : IRecommendationService
{
    public async Task<IEnumerable<Job>> GetRecommendationJobsAsync(int userId)
    {
        // 1. Fetch user's job preferences
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

        // 2. Fetch all active jobs
        var activeJobs = await context.Jobs
            .Where(job => job.Status == JobStatus.Active)
            .ToListAsync();

        // 3. Filter jobs based on content-based preferences
        var filteredJobs = activeJobs;
        if (jobPreferences != null)
        {
            filteredJobs = activeJobs
                .Where(job =>
                    (jobPreferences.Cities.Contains(job.CityId) || jobPreferences.Cities.Count == 0) &&
                    (jobPreferences.JobTypes.Contains(job.JobTypeId ?? 0) || jobPreferences.JobTypes.Count == 0))
                .ToList();
        }

        // 4. Exclude jobs the user has already interacted with
        var excludedJobIds = await context.JobApplications
            .Where(app => !app.IsDeleted && app.CreatedBy == userId)
            .Select(app => app.JobId)
            .Union(
                context.SavedJobs
                    .Where(saved => !saved.IsDeleted && saved.CreatedBy == userId)
                    .Select(saved => saved.JobId))
            .ToListAsync();

        // 5. Collaborative filtering: Find similar users and their jobs
        var similarUserJobIds = await context.JobApplications
            .Where(app => !app.IsDeleted && app.CreatedBy != userId)
            .GroupBy(app => app.CreatedBy) // Group by user ID
            .Select(g => new
            {
                UserId = g.Key,
                SharedJobs = g.Select(app => app.JobId).Intersect(
                    context.JobApplications
                        .Where(ua => !ua.IsDeleted && ua.CreatedBy == userId)
                        .Select(ua => ua.JobId)
                ).Count() // Count of shared jobs to determine similarity
            })
            .Where(user => user.SharedJobs > 0) // Filter users with shared interests
            .OrderByDescending(user => user.SharedJobs) // Rank by similarity
            .Take(10) // Limit to top 10 similar users
            .SelectMany(user =>
                context.JobApplications
                    .Where(app => app.CreatedBy == user.UserId && !app.IsDeleted)
                    .Select(app => app.JobId)
            )
            .Distinct()
            .ToListAsync();

        // 6. Fetch job ratings for filtered jobs
        var jobRatings = await context.Ratings
            .Where(r => filteredJobs.Select(job => job.Id).Contains(r.RatedUserId) && r.IsActive)
            .GroupBy(r => r.RatedUserId)
            .Select(g => new { UserId = g.Key, AverageRating = g.Average(r => r.Value) })
            .ToListAsync();

        // 7. Combine content-based and collaborative scores
        var jobScores = filteredJobs
            .Where(job => !excludedJobIds.Contains(job.Id)) // Exclude previously interacted jobs
            .Select(job => new
            {
                Job = job,
                ContentScore = (jobPreferences?.Cities.Contains(job.CityId) == true ? 1 : 0) +
                               (jobPreferences?.JobTypes.Contains(job.JobTypeId ?? 0) == true ? 1 : 0),
                CollaborativeScore = similarUserJobIds.Contains(job.Id) ? 1 : 0,
                AverageRating = jobRatings
                    .Where(r => r.UserId == job.CreatedBy)
                    .Select(r => r.AverageRating)
                    .DefaultIfEmpty(0)
                    .First()
            })
            .OrderByDescending(job => job.ContentScore * 0.5 + job.CollaborativeScore * 0.3 + job.AverageRating * 0.2) // Weighted ranking
            .Take(6) // Limit to top 6 recommendations
            .Select(j => j.Job)
            .ToList();

        // 8. Fetch related data and project into the desired format
        var result = jobScores
            .Select(job => new
            {
                Job = job,
                Schedules = context.JobQuestions
                    .Where(jq => jq.JobId == job.Id && jq.QuestionId == 1)
                    .Join(context.JobQuestionAnswers, jq => jq.Id, qa => qa.JobQuestionId, (jq, qa) => qa.ProposedAnswer)
                    .ToList(),
                PaymentQuestion = context.JobQuestions
                    .Where(jq => jq.JobId == job.Id && jq.QuestionId == 2)
                    .Join(context.JobQuestionAnswers, jq => jq.Id, qa => qa.JobQuestionId, (jq, qa) => qa.ProposedAnswer)
                    .FirstOrDefault(),
                AdditionalPaymentOptions = context.JobQuestions
                    .Where(jq => jq.JobId == job.Id && jq.QuestionId == 3)
                    .Join(context.JobQuestionAnswers, jq => jq.Id, qa => qa.JobQuestionId, (jq, qa) => qa.ProposedAnswer)
                    .ToList(),
                JobType = context.JobTypes.FirstOrDefault(jt => jt.Id == job.JobTypeId),
                City = context.Cities.FirstOrDefault(c => c.Id == job.CityId)
            })
            .Select(job => new Job
            {
                Id = job.Job.Id,
                Name = job.Job.Name,
                Description = job.Job.Description,
                StreetAddressAndNumber = job.Job.StreetAddressAndNumber,
                ApplicationsDuration = job.Job.ApplicationsDuration,
                Status = job.Job.Status,
                RequiredEmployees = job.Job.RequiredEmployees,
                Wage = job.Job.Wage,
                CityId = job.Job.CityId,
                JobTypeId = job.Job.JobTypeId,
                Created = job.Job.Created,
                CreatedBy = job.Job.CreatedBy,
                Schedules = job.Schedules,
                PaymentQuestion = job.PaymentQuestion,
                AdditionalPaymentOptions = job.AdditionalPaymentOptions,
                JobType = job.JobType,
                City = job.City
            })
            .ToList();

        // 9. Fallback to active jobs if no recommendations
        return result.Any() ? result : activeJobs.Take(6);
    }


}