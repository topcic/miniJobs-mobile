using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

sealed class JobCompleteApplicationsCommandHandler(IJobRepository jobRepository) : IRequestHandler<JobCompleteApplicationsCommand, Job>
{
    public async Task<Job> Handle(JobCompleteApplicationsCommand command, CancellationToken cancellationToken)

    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await jobRepository.TryFindAsync(command.JobId);

        job.MoveNext(JobCommand.ApplicationsCompleted);


        await jobRepository.UpdateAsync(job);

        job = await jobRepository.GetWithDetailsAsync(job.Id, false, command.UserId.Value);

        ts.Complete();

        return job;
    }
}