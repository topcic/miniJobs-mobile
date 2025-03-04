using Application.Countries.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Countries.Handlers;

sealed class CountryDeleteCommandHandler(ICountryRepository repository) : IRequestHandler<CountryDeleteCommand, Country>
{
    public async Task<Country> Handle(CountryDeleteCommand command, CancellationToken cancellationToken)
    {
        var model = await repository.TryFindAsync(command.Id);

        model.IsDeleted = true;

        await repository.UpdateAsync(model);
        return model;
    }
}