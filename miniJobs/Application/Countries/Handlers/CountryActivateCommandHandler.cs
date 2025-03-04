using Application.Countries.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Countries.Handlers;

sealed class CountryActivateCommandHandler(ICountryRepository repository) : IRequestHandler<CountryActivateCommand, Country>
{
    public async Task<Country> Handle(CountryActivateCommand command, CancellationToken cancellationToken)
    {
        var model = await repository.TryFindAsync(command.Id);

        model.IsDeleted = false;

        await repository.UpdateAsync(model);
        return model;
    }
}