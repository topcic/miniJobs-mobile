using Application.Cities.Commands;
using Application.Common.Extensions;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Cities.Validators;

public class CityActivateCommandValidator : AbstractValidator<CityActivateCommand>
{
    private readonly ICityRepository repository;
    public CityActivateCommandValidator(ICityRepository repository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x));
        this.repository = repository;
    }

    private async Task<bool> ValidateEntity(CityActivateCommand command)
    {
        var city = await repository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("CITY_NOT_EXISTS", () => city == null);

        return true;
    }
}