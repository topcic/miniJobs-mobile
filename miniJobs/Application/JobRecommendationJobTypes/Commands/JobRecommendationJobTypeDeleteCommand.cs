using Application.Common.Commands;

namespace Application.JobRecommendationJobTypes.Commands;

public class JobRecommendationJobTypeDeleteCommand(int jobRecommendationId) : CommandBase<bool>
{
    public int JobRecommendationId { get; set; } = jobRecommendationId;
}
