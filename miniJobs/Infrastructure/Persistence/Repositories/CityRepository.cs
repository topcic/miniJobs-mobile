namespace Infrastructure.Persistence.Repositories;

public class CityRepository(ApplicationDbContext context) : GenericRepository<City, int, ApplicationDbContext>(context), ICityRepository
{
}
