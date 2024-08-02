using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

public class JobActivateCommandHandler : IRequestHandler<JobActivateCommand, Job>
{
    private readonly IJobRepository _jobRepository;


    public JobActivateCommandHandler(IJobRepository jobRepository)
    {
        _jobRepository = jobRepository;
    }

    public async Task<Job> Handle(JobActivateCommand command, CancellationToken cancellationToken)

    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await _jobRepository.TryFindAsync(command.Id);

        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);

        job.MoveNext(JobCommand.Activate);

        await _jobRepository.UpdateAsync(job);

        var isApplicant = command.RoleId == Roles.Applicant.ToString();
        job = await _jobRepository.GetWithDetailsAsync(job.Id, isApplicant, command.UserId.Value);

        ts.Complete();

        return job;
    }
}