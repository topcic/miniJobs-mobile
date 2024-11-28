using Application.Common.Queries;
using Domain.Entities;

namespace Application.JobRecommendations.Queries;

public class JobRecommendationTryFindQuery(int id) : QueryBase<JobRecommendation>
{
    public int Id { get; set; } = id;
}
