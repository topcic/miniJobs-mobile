using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

public class JobApplyCommandHandler : IRequestHandler<JobApplyCommand, Job>
{
    private readonly IJobRepository jobRepository;
    private readonly IJobApplicationRepository jobApplicationRepository;



    public JobApplyCommandHandler(IJobRepository jobRepository, IJobApplicationRepository jobApplicationRepository)
    {
        this.jobRepository = jobRepository;
        this.jobApplicationRepository = jobApplicationRepository;
    }

    public async Task<Job> Handle(JobApplyCommand command, CancellationToken cancellationToken)

    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await jobRepository.GetWithDetailsAsync(command.Id, true, command.UserId.Value);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);

        if (command.Apply)
        {
            ExceptionExtension.Validate("ALREADY_APPLIED", () => job.IsApplied);
            var jobApplication = new JobApplication
            {
                JobId = job.Id,
                Created = DateTime.UtcNow,
                CreatedBy = command.UserId.Value,
                Status = JobApplicationStatus.Sent
            };

            await jobApplicationRepository.InsertAsync(jobApplication);
            job.IsApplied = true;

        }
        else
        {
            ExceptionExtension.Validate("JOB_APPLICATION_NOT_EXISTS", () => !job.IsApplied);
            var jobApplication = await jobApplicationRepository.FindOneAsync(x => x.CreatedBy == command.UserId.Value && x.JobId == job.Id);
            await jobApplicationRepository.DeleteAsync(jobApplication);
            job.IsApplied = false;
        }

        ts.Complete();

        return job;
    }
}