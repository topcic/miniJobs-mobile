using Application.Common.Commands;

namespace Application.JobRecommendations.Commands;

public class JobRecommendationNotifyUsersAboutMatchingJobCommand(int jobId, string jobName) : CommandBase<bool>
{
    public int JobId { get; set; } = jobId;
    public string JobName { get; set; } = jobName;
}
