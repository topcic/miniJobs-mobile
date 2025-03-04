using Application.Common.Exceptions;
using AutoMapper;
using Domain.Dtos;

namespace Infrastructure.Persistence.Repositories;

public class CityRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<City, int, ApplicationDbContext>(context, mapper), ICityRepository
{
    public async override Task<int> CountAsync(Dictionary<string, string> parameters = null)
    {

        var query = context.Cities.AsQueryable();

        if (parameters != null && parameters.TryGetValue("searchText", out string searchText) && !string.IsNullOrWhiteSpace(searchText))
        {
            query = query.Where(c => c.Name.Contains(searchText) ||
                                     c.Postcode.Contains(searchText) ||
                                     c.MunicipalityCode.Contains(searchText));
        }


        var count = await query.CountAsync();
        return count;
    }
    public async override Task<IEnumerable<City>> FindPaginationAsync(Dictionary<string, string> parameters = null)
    {
        var queryParameters = mapper.Map<QueryParametersDto>(parameters);

        // Base query
        var query = from c in context.Cities
                    join country in context.Countries on c.CountryId equals country.Id into countryGroup
                    from country in countryGroup.DefaultIfEmpty()
                    select new City
                    {
                        Id = c.Id,
                        Name = c.Name,
                        Postcode = c.Postcode,
                        MunicipalityCode = c.MunicipalityCode,
                        CountryId = c.CountryId,
                        Country = country
                    };

        // Filtering by search text
        if (!string.IsNullOrEmpty(queryParameters.SearchText))
        {
            query = query.Where(c => c.Name.Contains(queryParameters.SearchText) ||
                                     c.Postcode.Contains(queryParameters.SearchText) ||
                                     c.MunicipalityCode.Contains(queryParameters.SearchText));
        }

        // Sorting
        if (!string.IsNullOrEmpty(queryParameters.SortBy))
        {
            string columnName = QueryParameterExtension.GetMappedColumnName(queryParameters.SortBy, typeof(City));
            query = queryParameters.SortOrder == Domain.Enums.SortOrder.DESC
                ? query.OrderByDescending(c => EF.Property<object>(c, columnName))
                : query.OrderBy(c => EF.Property<object>(c, columnName));
        }

        // Pagination
        query = query.Skip(queryParameters.Offset).Take(queryParameters.Limit);

        return await query.ToListAsync();
    }


}
