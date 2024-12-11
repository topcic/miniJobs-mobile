using Application.Common.Queries;
using Domain.Entities;

namespace Application.JobRecommendations.Queries;

public class JobRecommendationTryFindQuery(int userId) : QueryBase<JobRecommendation>
{
    public int UserId { get; set; } = userId;
}
