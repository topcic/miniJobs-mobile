using Application.Common.Commands;
using Domain.Entities;

namespace Application.JobRecommendations.Commands;

public class JobRecommendationDeleteCommand(int id) : CommandBase<JobRecommendation>
{
    public int Id { get; set; } = id;
}
