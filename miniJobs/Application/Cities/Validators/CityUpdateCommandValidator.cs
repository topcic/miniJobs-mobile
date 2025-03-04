using Application.Cities.Commands;
using Application.Common.Extensions;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Cities.Validators;

public class CityUpdateCommandValidator : AbstractValidator<CityUpdateCommand>
{
    private readonly ICityRepository repository;
    public CityUpdateCommandValidator(ICityRepository repository)
    {
        RuleFor(x => x.Request.Name).NotEmpty().WithMessage("NAME_IS_REQUIRED");
        this.repository = repository;
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateEntity(x)).OverridePropertyName("Name").WithMessage("CITY_ALREADY_EXIST");
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateExistenceOfEntity(x));
    }
    private async Task<bool> ValidateEntity(CityUpdateCommand data)
    {
        return await repository.FindOneAsync(x => x.Name == data.Request.Name && x.CountryId == data.Request.CountryId && x.Id != data.Request.Id) == null;

    }
    private async Task<bool> ValidateExistenceOfEntity(CityUpdateCommand command)
    {
        var model = await repository.TryFindAsync(command.Request.Id);
        ExceptionExtension.Validate("CITY_NOT_EXISTS", () => model == null);

        return true;
    }
}