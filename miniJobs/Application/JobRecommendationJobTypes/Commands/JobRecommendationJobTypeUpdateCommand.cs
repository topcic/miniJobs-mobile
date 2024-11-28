using Application.Common.Commands;

namespace Application.JobRecommendationJobTypes.Commands;

public class JobRecommendationJobTypeUpdateCommand(List<int> jobTypes, int jobRecommendationId) : CommandBase<bool>
{
    public int JobRecommendationId { get; set; } = jobRecommendationId;
    public List<int> JobTypes { get; set; } = jobTypes;
}
