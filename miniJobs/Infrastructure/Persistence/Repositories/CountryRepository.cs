namespace Infrastructure.Persistence.Repositories;

public class CountryRepository(ApplicationDbContext context) : GenericRepository<Country, int, ApplicationDbContext>(context), ICountryRepository
{
}
