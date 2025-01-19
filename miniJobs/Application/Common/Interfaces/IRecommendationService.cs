using Domain.Entities;

namespace Application.Common.Interfaces;

public interface IRecommendationService
{
    Task<IEnumerable<Job>> GetRecommendationJobsAsync(int userId);
}
