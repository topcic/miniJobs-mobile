using Application.Cities.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Cities.Handlers;

public class CityUpdateCommandHandler(ICityRepository repository) : IRequestHandler<CityUpdateCommand, City>
{
    public async Task<City> Handle(CityUpdateCommand command, CancellationToken cancellationToken)
    {
        await repository.UpdateAsync(command.Request);
        return command.Request;
    }
}