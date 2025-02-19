using Domain.Dtos;
using Domain.Entities;

namespace Application.Common.Interfaces;

public interface IRecommendationService
{
    Task<IEnumerable<JobCardDTO>> GetRecommendationJobsAsync(int userId);
}
