using Application.Common.Extensions;
using Application.JobApplicationa.Commands;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;

namespace Application.JobApplications.Validators;

public class JobApplicationApplyCommandValidator : AbstractValidator<JobApplicationApplyCommand>
{
    private readonly IJobRepository jobRepository;

    public JobApplicationApplyCommandValidator(IJobRepository jobRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRepository = jobRepository;
    }

    private async Task<bool> ValidateEntity(JobApplicationApplyCommand command)
    {
        Job job = await jobRepository.GetWithDetailsAsync(command.JobId, true, command.UserId.Value);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);
        ExceptionExtension.Validate("CAN_NOT_APPLY_TO_JOB_IN_THIS_STATUS", () => job.Status != JobStatus.Active);

        ExceptionExtension.Validate("ALREADY_APPLIED", () => job.IsApplied);
        return true;
    }
}