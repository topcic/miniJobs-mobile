using Application.Cities.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Cities.Handlers;

sealed class CityDeleteCommandHandler(ICityRepository repository) : IRequestHandler<CityDeleteCommand, City>
{
    public async Task<City> Handle(CityDeleteCommand command, CancellationToken cancellationToken)
    {
        var model = await repository.TryFindAsync(command.Id);

        model.IsDeleted = true;

        await repository.UpdateAsync(model);
        return model;
    }
}