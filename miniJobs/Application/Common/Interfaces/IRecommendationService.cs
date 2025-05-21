using Domain.Dtos;
using Domain.Entities;

namespace Application.Common.Interfaces;

public interface IRecommendationService
{
    Task<RecommendationJobsDTO> GetRecommendationJobsAsync(int userId);
}
