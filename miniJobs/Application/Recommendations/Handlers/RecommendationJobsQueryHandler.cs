using Application.Common.Interfaces;
using Application.Recommendations.Queries;
using Domain.Entities;
using MediatR;

sealed class RecommendationJobsQueryHandler(IRecommendationService recommendationService) : IRequestHandler<RecommendationJobsQuery, IEnumerable<Job>>
{
    public async Task<IEnumerable<Job>> Handle(RecommendationJobsQuery query, CancellationToken cancellationToken)
    {

        return await recommendationService.GetRecommendationJobsAsync(query.UserId.Value);
    }
}