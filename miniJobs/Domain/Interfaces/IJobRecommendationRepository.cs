using Domain.Entities;

namespace Domain.Interfaces;

public interface IJobRecommendationRepository : IGenericRepository<JobRecommendation, int>
{
    Task<IEnumerable<User>> GetUsersByMatchingJobRecommendationsAsync(int jobId);
}
