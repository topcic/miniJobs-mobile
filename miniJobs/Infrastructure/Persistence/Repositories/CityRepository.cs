using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class CityRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<City, int, ApplicationDbContext>(context, mapper), ICityRepository
{
}
