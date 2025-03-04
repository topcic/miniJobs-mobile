using Application.Common.Commands;
using Domain.Entities;

namespace Application.JobTypes.Commands;

public class JobTypeUpdateCommand(JobType request) : CommandBase<JobType>
{
    public JobType Request { get; set; } = request;
}