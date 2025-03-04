using Application.Common.Extensions;
using Application.JobTypes.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.JobTypes.Validators;

public class JobTypeActivateCommandValidator : AbstractValidator<JobTypeActivateCommand>
{
    private readonly IJobTypeRepository repository;
    public JobTypeActivateCommandValidator(IJobTypeRepository repository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.repository = repository;
    }

    private async Task<bool> ValidateEntity(JobTypeActivateCommand command)
    {
        var city = await repository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("JOB_TYPE_NOT_EXISTS", () => city == null);

        return true;
    }
}