using Application.Common.Extensions;
using Application.JobApplications.Commands;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;

namespace Application.JobApplications.Validators;

public class JobApplicationDeleteCommandValidator : AbstractValidator<JobApplicationDeleteCommand>
{
    private readonly IJobApplicationRepository jobApplicationRepository;
    public JobApplicationDeleteCommandValidator(IJobApplicationRepository jobApplicationRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobApplicationRepository = jobApplicationRepository;
    }

    private async Task<bool> ValidateEntity(JobApplicationDeleteCommand command)
    {
        var jobApplication = await jobApplicationRepository.FindOneAsync(x => x.CreatedBy == command.UserId.Value && x.JobId == command.JobId && x.IsDeleted == false);

        ExceptionExtension.Validate("JOB_APPLICATION_NOT_EXISTS", () => jobApplication == null);
        ExceptionExtension.Validate("JOB_APPLICATION_CAN_NOT_BE_DELETED", () => jobApplication.Status != JobApplicationStatus.Sent);
        return true;
    }
}