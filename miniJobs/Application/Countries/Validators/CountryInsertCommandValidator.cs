using Application.Countries.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Countries.Validators;

public class CountryInsertCommandValidator : AbstractValidator<CountryInsertCommand>
{
    private readonly ICountryRepository repository;
    public CountryInsertCommandValidator(ICountryRepository repository)
    {
        RuleFor(x => x.Request.Name).NotEmpty().WithMessage("NAME_IS_REQUIRED");
        this.repository = repository;
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x)).OverridePropertyName("Name").WithMessage("COUNTRY_ALREADY_EXIST");
    }
    private async Task<bool> ValidateEntity(CountryInsertCommand data)
    {
        return await repository.FindOneAsync(x => x.Name == data.Request.Name) == null;

    }
}