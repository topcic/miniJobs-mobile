using Application.Cities.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Cities.Handlers;

public class CityFindAllQueryHandler(ICityRepository cityRepository,
                       ICountryRepository countryRepository) : IRequestHandler<CityFindAllQuery, IEnumerable<City>>
{
    public async Task<IEnumerable<City>> Handle(CityFindAllQuery request, CancellationToken cancellationToken)
    {
        var cities = await cityRepository.FindAllAsync();

        foreach (var city in cities)
        {
            if (city.CountryId.HasValue)
                city.Country = await countryRepository.TryFindAsync(city.CountryId.Value);
        }

        return cities;
    }
}