using Application.Common.Extensions;
using Application.Countries.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Countries.Validators;

public class CountryDeleteCommandValidator : AbstractValidator<CountryDeleteCommand>
{
    private readonly ICountryRepository repository;
    public CountryDeleteCommandValidator(ICountryRepository repository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.repository = repository;
    }

    private async Task<bool> ValidateEntity(CountryDeleteCommand command)
    {
        var model = await repository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("COUNTRY_NOT_EXISTS", () => model == null);

        return true;
    }
}