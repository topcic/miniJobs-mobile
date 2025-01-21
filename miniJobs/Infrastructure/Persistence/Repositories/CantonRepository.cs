using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class CantonRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<Canton, int, ApplicationDbContext>(context, mapper), ICantonRepository
{
}