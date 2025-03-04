using Application.Cities.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Cities.Validators;

public class CityInsertCommandValidator : AbstractValidator<CityInsertCommand>
{
    private readonly ICityRepository repository;
    public CityInsertCommandValidator(ICityRepository repository)
    {
        RuleFor(x => x.Request.Name).NotEmpty().WithMessage("NAME_IS_REQUIRED");
        this.repository = repository;
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x)).OverridePropertyName("Name").WithMessage("CITY_ALREADY_EXIST");
    }
    private async Task<bool> ValidateEntity(CityInsertCommand data)
    {
            return await repository.FindOneAsync(x => x.Name == data.Request.Name && x.CountryId==data.Request.CountryId) == null;

    }
}