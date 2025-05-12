using Application.JobTypes.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobTypes.Handlers;

sealed class JobTypeUpdateCommandHandler(IJobTypeRepository repository) : IRequestHandler<JobTypeUpdateCommand, JobType>
{
    public async Task<JobType> Handle(JobTypeUpdateCommand command, CancellationToken cancellationToken)
    {
        await repository.UpdateAsync(command.Request);
        return command.Request;
    }
}