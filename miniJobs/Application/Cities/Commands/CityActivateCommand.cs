using Application.Common.Commands;
using Domain.Entities;

namespace Application.Cities.Commands;

public class CityActivateCommand(int id) : CommandBase<City>
{
    public int Id { get; set; } = id;
}