using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobActivateCommandValidator : AbstractValidator<JobActivateCommand>
{
    private readonly IJobRepository jobRepository;
    public JobActivateCommandValidator(IJobRepository jobRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRepository = jobRepository;
    }

    private async Task<bool> ValidateEntity(JobActivateCommand command)
    {
        Job job = await jobRepository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);
        ExceptionExtension.Validate("NO_ACTIONS_POSSIBLE_BECAUSE_HAS_BEEN_DELETED_BY_ADMIN", () => job.DeletedByAdmin);
        return true;
    }
}