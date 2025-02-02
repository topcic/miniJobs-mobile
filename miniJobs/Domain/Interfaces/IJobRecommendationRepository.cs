using Domain.Dtos;
using Domain.Entities;

namespace Domain.Interfaces;

public interface IJobRecommendationRepository : IGenericRepository<JobRecommendation, int>
{
    Task<IEnumerable<User>> GetUsersByMatchingJobRecommendationsAsync(int jobId);
    Task<int> PublicCountAsync(Dictionary<string, string> parameters = null);
    Task<IEnumerable<JobRecommendationDTO>> PublicFindPaginationAsync(Dictionary<string, string> parameters = null);
}
