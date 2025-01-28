using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;
sealed class JobDeleteByAdminCommandHandler(IJobRepository jobRepository) : IRequestHandler<JobDeleteByAdminCommand, Job>
{
    public async Task<Job> Handle(JobDeleteByAdminCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        var job = await jobRepository.TryFindAsync(command.Id);
        job.DeletedByAdmin = true;
        await jobRepository.UpdateAsync(job);
        ts.Complete();
        return job;
    }
}