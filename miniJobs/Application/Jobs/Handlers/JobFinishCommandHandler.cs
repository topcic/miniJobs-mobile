using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

sealed class JobFinishCommandHandler(IJobRepository jobRepository) : IRequestHandler<JobFinishCommand, Job>
{
    public async Task<Job> Handle(JobFinishCommand command, CancellationToken cancellationToken)

    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await jobRepository.TryFindAsync(command.JobId);

        job.MoveNext(JobCommand.Complete);

        var acceptedApplicants = (await jobRepository.GetApplicantAppliedJobsAsync(command.JobId))
            .Where(x => x.Status == JobApplicationStatus.Accepted)
            .ToList();

        await jobRepository.UpdateAsync(job);

        job = await jobRepository.GetWithDetailsAsync(job.Id, false, command.UserId.Value);

        ts.Complete();

        return job;
    }
}