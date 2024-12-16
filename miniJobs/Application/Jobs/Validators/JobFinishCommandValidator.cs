using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobFinishCommandValidator : AbstractValidator<JobFinishCommand>
{
    private readonly IJobRepository jobRepository;
    public JobFinishCommandValidator( IJobRepository jobRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRepository = jobRepository;
    }

    private async Task<bool> ValidateEntity(JobFinishCommand command)
    {
        Job job = await jobRepository.TryFindAsync(command.JobId);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);
        return true;
    }
}