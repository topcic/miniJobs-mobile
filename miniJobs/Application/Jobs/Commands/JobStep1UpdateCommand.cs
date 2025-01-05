using Application.Common.Commands;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobStep1UpdateCommand(Job request) : CommandBase<Job>
{
    public Job Request { get; set; } = request;
}
