using Application.Common.Extensions;
using Application.JobApplications.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;

namespace Application.JobApplications.Validators;

public class JobApplicationAcceptCommandValidator : AbstractValidator<JobApplicationAcceptCommand>
{
    private readonly IJobApplicationRepository jobApplicationRepository;
    private readonly IJobRepository jobRepository;
    public JobApplicationAcceptCommandValidator(IJobApplicationRepository jobApplicationRepository, IJobRepository jobRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobApplicationRepository = jobApplicationRepository;
        this.jobRepository = jobRepository;
    }

    private async Task<bool> ValidateEntity(JobApplicationAcceptCommand command)
    {
        var jobApplication = await jobApplicationRepository.TryFindAsync(command.JobApplicationId);
        ExceptionExtension.Validate("JOB_APPLICATION_NOT_EXISTS", () => jobApplication == null);
        ExceptionExtension.Validate("JOB_APPLICATION_IS_DELETED", () => jobApplication.IsDeleted);
        ExceptionExtension.Validate("JOB_APPLICATION_ALREADY_ACCEPTED", () => jobApplication.Status == JobApplicationStatus.Accepted);
        ExceptionExtension.Validate("JOB_APPLICATION_ALREADY_REJECTED", () => jobApplication.Status == JobApplicationStatus.Rejected);

        Job job = await jobRepository.GetWithDetailsAsync(command.JobId, true, command.UserId.Value);
        ExceptionExtension.Validate("ACTION_NOT_POSSIBLE_IN_THIS_JOB_STATUS", () => job.Status != JobStatus.ApplicationsCompleted);
        return true;
    }
}