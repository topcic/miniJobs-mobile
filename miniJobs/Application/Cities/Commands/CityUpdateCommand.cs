using Application.Common.Commands;
using Domain.Entities;

namespace Application.Cities.Commands;

public class CityUpdateCommand(City request) : CommandBase<City>
{
    public City Request { get; set; } = request;
}