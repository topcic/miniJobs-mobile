using Application.Common.Extensions;
using Application.Countries.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Countries.Validators;

public class CountryUpdateCommandValidator : AbstractValidator<CountryUpdateCommand>
{
    private readonly ICountryRepository repository;
    public CountryUpdateCommandValidator(ICountryRepository repository)
    {
        RuleFor(x => x.Request.Name).NotEmpty().WithMessage("NAME_IS_REQUIRED");
        this.repository = repository;
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x)).OverridePropertyName("Name").WithMessage("COUNTRY_ALREADY_EXIST");

        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateExistenceOfEntity(x));

    }
    private async Task<bool> ValidateEntity(CountryUpdateCommand data)
    {
        return await repository.FindOneAsync(x => x.Name == data.Request.Name && x.Id != data.Request.Id) == null;

    }
    private async Task<bool> ValidateExistenceOfEntity(CountryUpdateCommand command)
    {
        var model = await repository.TryFindAsync(command.Request.Id);
        ExceptionExtension.Validate("COUNTRY_NOT_EXISTS", () => model == null);

        return true;
    }
}