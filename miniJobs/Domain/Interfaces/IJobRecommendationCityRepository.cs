using Domain.Entities;

namespace Domain.Interfaces;

public interface IJobRecommendationCityRepository
{
    Task InsertRangeAsync(IEnumerable<JobRecommendationCity> jobRecommendationCities);
    Task<bool> DeleteAsync(int jobRecommendationId, int cityId);
    Task<IEnumerable<City>> FindAllAsync(int jobRecommendationId);
    Task<JobRecommendationCity> TryFindAsync(int jobRecommendationId, int cityId);
}
