using Domain.Entities;
using MediatR;

namespace Application.Cities.Queries;

public class CityFindAllQuery : IRequest<IEnumerable<City>>
{
}