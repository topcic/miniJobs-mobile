using Application.Common.Interfaces;
using Application.Recommendations.Queries;
using Domain.Dtos;
using Domain.Entities;
using MediatR;

sealed class RecommendationJobsQueryHandler(IRecommendationService recommendationService) : IRequestHandler<RecommendationJobsQuery, IEnumerable<JobCardDTO>>
{
    public async Task<IEnumerable<JobCardDTO>> Handle(RecommendationJobsQuery query, CancellationToken cancellationToken)
    {

        return await recommendationService.GetRecommendationJobsAsync(query.UserId.Value);
    }
}