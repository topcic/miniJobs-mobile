using Application.Common.Commands;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobFinishCommand(int jobId) : CommandBase<Job>
{
    public int JobId { get; set; } = jobId;
}
