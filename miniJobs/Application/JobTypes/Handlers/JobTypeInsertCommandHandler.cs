using Application.JobTypes.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.JobTypes.Handlers;

sealed class JobTypeInsertCommandHandler(IJobTypeRepository repository) : IRequestHandler<JobTypeInsertCommand, JobType>
{
    public async Task<JobType> Handle(JobTypeInsertCommand command, CancellationToken cancellationToken)
    {
        await repository.InsertAsync(command.Request);
        return command.Request;
    }
}