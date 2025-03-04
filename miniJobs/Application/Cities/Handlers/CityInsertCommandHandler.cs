using Application.Cities.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Cities.Handlers;

sealed class CityInsertCommandHandler(ICityRepository repository) : IRequestHandler<CityInsertCommand, City>
{
    public async Task<City> Handle(CityInsertCommand command, CancellationToken cancellationToken)
    {
        await repository.InsertAsync(command.Request);
        return command.Request;
    }
}