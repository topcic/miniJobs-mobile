namespace Infrastructure.Persistence.Repositories;

public class RatingRepository(ApplicationDbContext context) : GenericRepository<Rating, int, ApplicationDbContext>(context), IRatingRepository
{
}
