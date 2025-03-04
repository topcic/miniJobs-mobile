using Application.Common.Extensions;
using Application.JobTypes.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.JobTypes.Validators;

public class JobTypeUpdateCommandValidator : AbstractValidator<JobTypeUpdateCommand>
{
    private readonly IJobTypeRepository repository;
    public JobTypeUpdateCommandValidator(IJobTypeRepository repository)
    {
        RuleFor(x => x.Request.Name).NotEmpty().WithMessage("NAME_IS_REQUIRED");
        this.repository = repository;
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x)).OverridePropertyName("Name").WithMessage("JOB_TYPE_ALREADY_EXIST");
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateExistenceOfEntity(x));
    }
    private async Task<bool> ValidateEntity(JobTypeUpdateCommand data)
    {
        return await repository.FindOneAsync(x => x.Name == data.Request.Name && x.Id != data.Request.Id) == null;

    }
    private async Task<bool> ValidateExistenceOfEntity(JobTypeUpdateCommand command)
    {
        var model = await repository.TryFindAsync(command.Request.Id);
        ExceptionExtension.Validate("CITY_NOT_EXISTS", () => model == null);

        return true;
    }
}