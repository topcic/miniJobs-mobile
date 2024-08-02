using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

public class JobDeleteCommandHandler : IRequestHandler<JobDeleteCommand, Job>
{

    private readonly IJobRepository jobRepository;

    public JobDeleteCommandHandler(IJobRepository jobRepository)
    {
        this.jobRepository = jobRepository;
    }
    public async Task<Job> Handle(JobDeleteCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        var job = await jobRepository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("JOB_NOT_EXIST", () => job == null);
        job.MoveNext(JobCommand.Delete);

        await jobRepository.UpdateAsync(job);
        ts.Complete();
        return job;
    }
}