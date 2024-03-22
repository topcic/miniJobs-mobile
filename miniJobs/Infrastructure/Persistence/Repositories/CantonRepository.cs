namespace Infrastructure.Persistence.Repositories;

public class CantonRepository(ApplicationDbContext context) : GenericRepository<Canton, int, ApplicationDbContext>(context), ICantonRepository
{
}