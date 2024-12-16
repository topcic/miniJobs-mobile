using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

sealed class JobDeleteCommandHandler(IJobRepository jobRepository) : IRequestHandler<JobDeleteCommand, Job>
{
    public async Task<Job> Handle(JobDeleteCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        var job = await jobRepository.TryFindAsync(command.Id);
        job.MoveNext(JobCommand.Delete);

        await jobRepository.UpdateAsync(job);
        ts.Complete();
        return job;
    }
}