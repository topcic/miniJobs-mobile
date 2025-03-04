using Application.Cities.Commands;
using Application.Common.Extensions;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Cities.Validators;

public class CityDeleteCommandValidator : AbstractValidator<CityDeleteCommand>
{
    private readonly ICityRepository repository;
    public CityDeleteCommandValidator(ICityRepository repository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.repository = repository;
    }

    private async Task<bool> ValidateEntity(CityDeleteCommand command)
    {
        var city = await repository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("CITY_NOT_EXISTS", () => city == null);

        return true;
    }
}