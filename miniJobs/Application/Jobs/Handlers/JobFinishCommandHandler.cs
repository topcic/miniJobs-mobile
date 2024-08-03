using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

public class JobFinishCommandHandler : IRequestHandler<JobFinishCommand, Job>
{
    private readonly IJobRepository _jobRepository;

    public JobFinishCommandHandler(IJobRepository jobRepository)
    {
        _jobRepository = jobRepository;
    }

    public async Task<Job> Handle(JobFinishCommand command, CancellationToken cancellationToken)

    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await _jobRepository.TryFindAsync(command.JobId);

        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);

        job.MoveNext(JobCommand.Complete);

        var applications= await _jobRepository.GetApplicants(command.JobId);

        ExceptionExtension.Validate("CANNOT_FINISH_JOB_WITHOUT_APPLICANTS", () => applications.Count()==0);
        var ratedApplicants= applications.Where(x=>x.IsRated==true).ToList();
        ExceptionExtension.Validate("AT_LEAST_ONE_APPLICANT_NEED_TO_BE_RATED", () => ratedApplicants.Count() == 0);

        await _jobRepository.UpdateAsync(job);

        var isApplicant = command.RoleId == Roles.Applicant.ToString();
        job = await _jobRepository.GetWithDetailsAsync(job.Id, isApplicant, command.UserId.Value);

        ts.Complete();

        return job;
    }
}