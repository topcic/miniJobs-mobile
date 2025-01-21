using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class RatingRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<Rating, int, ApplicationDbContext>(context, mapper), IRatingRepository
{
}
