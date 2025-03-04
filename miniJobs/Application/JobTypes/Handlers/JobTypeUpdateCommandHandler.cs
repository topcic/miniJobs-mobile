using Application.JobTypes.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobTypes.Handlers;

sealed class JobTypeUpdateCommandHandler(IJobTypeRepository repository) : IRequestHandler<JobTypeInsertCommand, JobType>
{
    public async Task<JobType> Handle(JobTypeInsertCommand command, CancellationToken cancellationToken)
    {
        await repository.UpdateAsync(command.Request);
        return command.Request;
    }
}