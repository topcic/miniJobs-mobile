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
        var cities =  cityRepository.Find(x=>x.IsDeleted==false);

        foreach (var city in cities)
        {
                city.CountryName =( await countryRepository.TryFindAsync(city.CountryId)).Name;
        }

        return cities;
    }
}