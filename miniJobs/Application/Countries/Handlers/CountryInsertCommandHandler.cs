using Application.Countries.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Countries.Handlers;

sealed class CountryInsertCommandHandler(ICountryRepository repository) : IRequestHandler<CountryInsertCommand, Country>
{
    public async Task<Country> Handle(CountryInsertCommand command, CancellationToken cancellationToken)
    {
        await repository.InsertAsync(command.Request);
        return command.Request;
    }
}