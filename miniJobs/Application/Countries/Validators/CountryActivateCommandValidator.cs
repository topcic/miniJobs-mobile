using Application.Common.Extensions;
using Application.Countries.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Countries.Validators;

public class CountryActivateCommandValidator : AbstractValidator<CountryActivateCommand>
{
    private readonly ICountryRepository repository;
    public CountryActivateCommandValidator(ICountryRepository repository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.repository = repository;
    }

    private async Task<bool> ValidateEntity(CountryActivateCommand command)
    {
        var model = await repository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("COUNTRY_NOT_EXISTS", () => model == null);

        return true;
    }
}