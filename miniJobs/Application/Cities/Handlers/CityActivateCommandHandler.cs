using Application.Cities.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Cities.Handlers;

sealed class CityActivateCommandHandler(ICityRepository repository) : IRequestHandler<CityActivateCommand, City>
{
    public async Task<City> Handle(CityActivateCommand command, CancellationToken cancellationToken)
    {
        var model = await repository.TryFindAsync(command.Id);

        model.IsDeleted = false;

        await repository.UpdateAsync(model);
        return model;
    }
}