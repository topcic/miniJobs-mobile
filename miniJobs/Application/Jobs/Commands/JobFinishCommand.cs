using Application.Common.Commands;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobFinishCommand : CommandBase<Job>
{
    public int JobId { get; set; }
    public JobFinishCommand(int jobId)
    {
        JobId = jobId;
    }
}
