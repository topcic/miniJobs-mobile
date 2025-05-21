using Application.Common.Interfaces;
using Application.Recommendations.Queries;
using Domain.Dtos;
using MediatR;

sealed class RecommendationJobsQueryHandler(IRecommendationService recommendationService) : IRequestHandler<RecommendationJobsQuery, RecommendationJobsDTO>
{
    public async Task<RecommendationJobsDTO> Handle(RecommendationJobsQuery query, CancellationToken cancellationToken)
    {

        return await recommendationService.GetRecommendationJobsAsync(query.UserId.Value);
    }
}