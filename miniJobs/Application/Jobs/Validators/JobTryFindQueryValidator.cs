using Application.Common.Extensions;
using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Jobs.Validators;

public class JobTryFindQueryValidator : AbstractValidator<JobTryFindQuery>
{
    private readonly IJobRepository jobRepository;
    public JobTryFindQueryValidator(IJobRepository jobRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.jobRepository = jobRepository;
    }

    private async Task<bool> ValidateEntity(JobTryFindQuery command)
    {
        Job job = await jobRepository.TryFindAsync(command.JobId);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);
        return true;
    }
}