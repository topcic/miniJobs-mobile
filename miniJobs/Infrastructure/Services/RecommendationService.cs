using Application.Common.Interfaces;
using Domain.Dtos;
using Domain.Enums;
using Infrastructure.Persistence;
using Microsoft.EntityFrameworkCore;

namespace Infrastructure.Services;

public class RecommendationService : IRecommendationService
{
    private readonly ApplicationDbContext _context;

    public RecommendationService(ApplicationDbContext context)
    {
        _context = context;
    }

    public async Task<IEnumerable<JobCardDTO>> GetRecommendationJobsAsync(int userId)
    {

        var userProfile = await GetUserProfileVector(userId);
        var jobs = await GetJobFeatureVectors();
        var contentBasedScores = CalculateContentBasedScores(userProfile, jobs);

        var similarUsers = await FindSimilarUsers(userId);
        var collaborativeJobs = await GetCollaborativeJobs(similarUsers);

        var employerRatings = await GetEmployerRatings(jobs.Select(j => j.Id));
        var employeeRating = await GetEmployeeRating(userId);

        var finalRecommendations = CombineAndRankRecommendations(
            contentBasedScores,
            collaborativeJobs,
            employerRatings,
            employeeRating
        );

        return MapToJobCardDTOs(finalRecommendations);

    }

    private async Task<UserProfileVector> GetUserProfileVector(int userId)
    {
        var preferences = await _context.JobRecommendations
            .Where(jr => jr.CreatedBy == userId)
            .Select(jr => new UserProfileVector
            {
                PreferredCities = _context.JobRecommendationCities
                    .Where(jrc => jrc.JobRecommendationId == jr.Id)
                    .Select(jrc => jrc.CityId)
                    .ToList(),
                PreferredJobTypes = _context.JobRecommendationJobTypes
                    .Where(jrt => jrt.JobRecommendationId == jr.Id)
                    .Select(jrt => jrt.JobTypeId)
                    .ToList(),
                PastApplications = _context.JobApplications
                    .Where(ja => ja.CreatedBy == userId && !ja.IsDeleted)
                    .Select(ja => ja.JobId)
                    .ToList()
            })
            .FirstOrDefaultAsync();

        return preferences ?? new UserProfileVector();
    }

    private async Task<List<JobFeatureVector>> GetJobFeatureVectors()
    {
        return await _context.Jobs
            .Where(j => j.Status == JobStatus.Active)
            .Select(j => new JobFeatureVector
            {
                Id = j.Id,
                CityId = j.CityId,
                JobTypeId = j.JobTypeId ?? 0,
                EmployerId = j.CreatedBy.Value
            })
            .ToListAsync();
    }

    private List<(int JobId, double Score)> CalculateContentBasedScores(
        UserProfileVector userProfile,
        List<JobFeatureVector> jobs)
    {
        var scores = new List<(int JobId, double Score)>();

        foreach (var job in jobs)
        {
            double cityMatch = userProfile.PreferredCities.Contains(job.CityId) ? 1.0 : 0.0;
            double jobTypeMatch = userProfile.PreferredJobTypes.Contains(job.JobTypeId) ? 1.0 : 0.0;

            double distance = Math.Sqrt(
                Math.Pow(cityMatch - 1, 2) +
                Math.Pow(jobTypeMatch - 1, 2)
            );

            double similarity = 1 / (1 + distance);
            scores.Add((job.Id, similarity));
        }

        return scores;
    }

    private async Task<List<(int UserId, double Similarity)>> FindSimilarUsers(int userId)
    {
        var userApplications = await _context.JobApplications
            .Where(ja => !ja.IsDeleted)
            .GroupBy(ja => ja.CreatedBy)
            .Select(g => new
            {
                UserId = g.Key,
                JobIds = g.Select(ja => ja.JobId).ToList()
            })
            .ToListAsync();

        var userRatings = await (from r in _context.Ratings
                                 join ur in _context.UserRoles on r.RatedUserId equals ur.UserId
                                 join role in _context.Roles on ur.RoleId equals role.Id
                                 where r.IsActive && role.Id == "Employee" // Ocjene radnika
                                 group r by r.RatedUserId into g
                                 select new
                                 {
                                     UserId = g.Key,
                                     AvgRating = g.Average(r => r.Value)
                                 }).ToListAsync();

        var targetUserApps = userApplications
            .FirstOrDefault(ua => ua.UserId == userId)?.JobIds ?? new List<int>();
        var targetUserRating = userRatings
            .FirstOrDefault(ur => ur.UserId == userId)?.AvgRating ?? 0.0;

        var similarities = new List<(int UserId, double Similarity)>();

        foreach (var user in userApplications.Where(ua => ua.UserId != userId))
        {
            var otherUserRating = userRatings
                .FirstOrDefault(ur => ur.UserId == user.UserId)?.AvgRating ?? 0.0;

            double appSimilarity = CalculatePearsonCorrelation(targetUserApps, user.JobIds);
            double ratingSimilarity = 1 - Math.Abs(targetUserRating - otherUserRating) / 5.0;
            double combinedSimilarity = 0.7 * appSimilarity + 0.3 * ratingSimilarity;

            if (combinedSimilarity > 0)
            {
                similarities.Add((user.UserId.Value, combinedSimilarity));
            }
        }

        return similarities.OrderByDescending(s => s.Similarity)
                         .Take(10)
                         .ToList();
    }

    private double CalculatePearsonCorrelation(List<int> user1Jobs, List<int> user2Jobs)
    {
        var commonJobs = user1Jobs.Intersect(user2Jobs).ToList();
        if (commonJobs.Count == 0) return 0;

        var allJobs = user1Jobs.Union(user2Jobs).ToList();
        var x = allJobs.Select(j => user1Jobs.Contains(j) ? 1.0 : 0.0).ToList();
        var y = allJobs.Select(j => user2Jobs.Contains(j) ? 1.0 : 0.0).ToList();

        double meanX = x.Average();
        double meanY = y.Average();

        double numerator = 0;
        double denominatorX = 0;
        double denominatorY = 0;

        for (int i = 0; i < x.Count; i++)
        {
            double diffX = x[i] - meanX;
            double diffY = y[i] - meanY;
            numerator += diffX * diffY;
            denominatorX += diffX * diffX;
            denominatorY += diffY * diffY;
        }

        if (denominatorX == 0 || denominatorY == 0) return 0;

        return numerator / (Math.Sqrt(denominatorX) * Math.Sqrt(denominatorY));
    }

    private async Task<List<(int JobId, double Score)>> GetCollaborativeJobs(
    List<(int UserId, double Similarity)> similarUsers)
    {
        if (!similarUsers.Any())
            return new List<(int JobId, double Score)>();

        var similarUserDict = similarUsers.ToDictionary(x => x.UserId, x => x.Similarity);
        var similarUserIds = similarUserDict.Keys.ToList();

        var jobApplications = await _context.JobApplications
            .Where(ja => !ja.IsDeleted && ja.CreatedBy.HasValue && similarUserIds.Contains(ja.CreatedBy.Value))
            .ToListAsync();

        var grouped = jobApplications
            .GroupBy(ja => ja.JobId)
            .Select(g => (
                JobId: g.Key,
                Score: g
                    .Where(ja => ja.CreatedBy.HasValue)
                    .Sum(ja => similarUserDict.TryGetValue(ja.CreatedBy.Value, out var sim) ? sim : 0)
            ))
            .ToList();

        return grouped;
    }

    private async Task<Dictionary<int, double>> GetEmployerRatings(IEnumerable<int> jobIds)
    {
        var jobEmployerMap = await _context.Jobs
            .Where(j => jobIds.Contains(j.Id))
            .Select(j => new { j.Id, j.CreatedBy })
            .ToDictionaryAsync(j => j.Id, j => j.CreatedBy);

        var ratings = await (from r in _context.Ratings
                             join ur in _context.UserRoles on r.CreatedBy equals ur.UserId
                             join role in _context.Roles on ur.RoleId equals role.Id
                             where r.IsActive && role.Id == "Employee" && // Ocjene poslodavaca od radnika
                                   jobEmployerMap.Values.Contains(r.RatedUserId)
                             group r by r.RatedUserId into g
                             select new
                             {
                                 EmployerId = g.Key,
                                 AverageRating = g.Average(r => r.Value)
                             }).ToDictionaryAsync(r => r.EmployerId, r => r.AverageRating);

        return jobEmployerMap.ToDictionary(
            kvp => kvp.Key,
            kvp => ratings.ContainsKey(kvp.Value.Value) ? ratings[kvp.Value.Value] : 0.0
        );
    }

    private async Task<double> GetEmployeeRating(int userId)
    {
        var ratings = await (from r in _context.Ratings
                             join ur in _context.UserRoles on r.CreatedBy equals ur.UserId
                             join role in _context.Roles on ur.RoleId equals role.Id
                             where r.IsActive && role.Id == "Employer" && r.RatedUserId == userId
                             select r.Value).ToListAsync();

        return ratings.Any() ? ratings.Average() : 0.0;
    }

    private List<(int JobId, double FinalScore)> CombineAndRankRecommendations(
        List<(int JobId, double Score)> contentBasedScores,
        List<(int JobId, double Score)> collaborativeJobs,
        Dictionary<int, double> employerRatings,
        double employeeRating)
    {
        var allJobIds = contentBasedScores.Select(c => c.JobId)
            .Union(collaborativeJobs.Select(c => c.JobId))
            .Distinct();

        var finalScores = new List<(int JobId, double FinalScore)>();

        const double CONTENT_WEIGHT = 0.35;
        const double COLLABORATIVE_WEIGHT = 0.25;
        const double EMPLOYER_RATING_WEIGHT = 0.25;
        const double EMPLOYEE_RATING_WEIGHT = 0.15;

        foreach (var jobId in allJobIds)
        {
            var contentScore = contentBasedScores
                .FirstOrDefault(c => c.JobId == jobId).Score;
            var collabScore = collaborativeJobs
                .FirstOrDefault(c => c.JobId == jobId).Score;
            var employerRatingScore = employerRatings.ContainsKey(jobId) ?
                employerRatings[jobId] / 5.0 : 0.0;
            var employeeRatingScore = employeeRating / 5.0;

            var finalScore = (contentScore * CONTENT_WEIGHT) +
                            (collabScore * COLLABORATIVE_WEIGHT) +
                            (employerRatingScore * EMPLOYER_RATING_WEIGHT) +
                            (employeeRatingScore * EMPLOYEE_RATING_WEIGHT);

            finalScores.Add((jobId, finalScore));
        }

        return finalScores
            .OrderByDescending(f => f.FinalScore)
            .Take(6)
            .ToList();
    }

    private IEnumerable<JobCardDTO> MapToJobCardDTOs(
        List<(int JobId, double FinalScore)> recommendations)
    {
        var jobIds = recommendations.Select(r => r.JobId).ToList();

        var jobs = _context.Jobs
            .Where(j => jobIds.Contains(j.Id))
            .Select(j => new
            {
                j.Id,
                j.Name,
                j.Wage,
                CityName = _context.Cities
                    .FirstOrDefault(c => c.Id == j.CityId)!.Name
            })
            .ToDictionary(j => j.Id);

        return recommendations.Select(r => new JobCardDTO
        {
            Id = r.JobId,
            Name = jobs[r.JobId].Name,
            CityName = jobs[r.JobId].CityName,
            Wage = jobs[r.JobId].Wage
        });
    }

    private record UserProfileVector
    {
        public List<int> PreferredCities { get; set; } = new();
        public List<int> PreferredJobTypes { get; set; } = new();
        public List<int> PastApplications { get; set; } = new();
    }

    private record JobFeatureVector
    {
        public int Id { get; set; }
        public int CityId { get; set; }
        public int JobTypeId { get; set; }
        public int EmployerId { get; set; }
    }
}