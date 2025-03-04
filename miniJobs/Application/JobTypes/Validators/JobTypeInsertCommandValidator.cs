using Application.JobTypes.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.JobTypes.Validators;

public class JobTypeInsertCommandValidator : AbstractValidator<JobTypeInsertCommand>
{
    private readonly IJobTypeRepository repository;
    public JobTypeInsertCommandValidator(IJobTypeRepository repository)
    {
        RuleFor(x => x.Request.Name).NotEmpty().WithMessage("NAME_IS_REQUIRED");
        this.repository = repository;
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x)).OverridePropertyName("Name").WithMessage("JOB_TYPE_ALREADY_EXIST");
    }
    private async Task<bool> ValidateEntity(JobTypeInsertCommand data)
    {
        return await repository.FindOneAsync(x => x.Name == data.Request.Name) == null;

    }
}