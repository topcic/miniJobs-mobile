using Application.Common.Commands;
using Domain.Entities;

namespace Application.JobApplicationa.Commands;

public class JobApplicationApplyCommand(int jobId) : CommandBase<JobApplication>
{
    public int JobId { get; set; } = jobId;
}
