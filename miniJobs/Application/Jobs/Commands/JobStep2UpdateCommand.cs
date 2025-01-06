using Application.Common.Commands;
using Application.Jobs.Models;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobStep2UpdateCommand(JobStep2Request request) : CommandBase<Job>
{
    public JobStep2Request Request { get; set; } = request;
}
