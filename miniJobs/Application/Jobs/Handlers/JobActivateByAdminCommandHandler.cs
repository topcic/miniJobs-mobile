using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;
sealed class JobActivateByAdminCommandHandler(IJobRepository jobRepository) : IRequestHandler<JobActivateByAdminCommand, Job>
{
    public async Task<Job> Handle(JobActivateByAdminCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        var job = await jobRepository.TryFindAsync(command.Id);
        job.DeletedByAdmin = false;
        await jobRepository.UpdateAsync(job);
        ts.Complete();
        return job;
    }
}