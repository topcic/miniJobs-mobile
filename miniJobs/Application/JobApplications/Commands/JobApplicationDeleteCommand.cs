using Application.Common.Commands;
using Domain.Entities;

namespace Application.JobApplications.Commands;

public class JobApplicationDeleteCommand(int jobId) : CommandBase<JobApplication>
{
    public int JobId { get; set; } = jobId;
}