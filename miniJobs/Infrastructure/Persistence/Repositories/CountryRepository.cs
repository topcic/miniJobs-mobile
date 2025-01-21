using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class CountryRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<Country, int, ApplicationDbContext>(context, mapper), ICountryRepository
{
}
