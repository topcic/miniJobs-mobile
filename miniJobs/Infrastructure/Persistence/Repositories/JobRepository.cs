namespace Infrastructure.Persistence.Repositories;

public class JobRepository(ApplicationDbContext context) : GenericRepository<Job, int, ApplicationDbContext>(context), IJobRepository
{
}
