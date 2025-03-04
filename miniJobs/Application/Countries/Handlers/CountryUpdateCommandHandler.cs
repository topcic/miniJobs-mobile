using Application.Countries.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Countries.Handlers;

sealed class CountryUpdateCommandHandler(ICountryRepository repository) : IRequestHandler<CountryUpdateCommand, Country>
{
    public async Task<Country> Handle(CountryUpdateCommand command, CancellationToken cancellationToken)
    {
        await repository.UpdateAsync(command.Request);
        return command.Request;
    }
}