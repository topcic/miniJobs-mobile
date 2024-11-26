using Domain.Entities;

namespace Domain.Interfaces;

public interface IJobRecommendationJobTypeRepository
{
    Task InsertRangeAsync(IEnumerable<JobRecommendationJobType> jobRecommendationJobTypes);
    Task<bool> DeleteAsync(int jobRecommendationId, int jobTypeId);
    Task<IEnumerable<JobType>> FindAllAsync(int jobRecommendationId);
    Task<JobRecommendationJobType> TryFindAsync(int jobRecommendationId, int jobTypeId);
}
