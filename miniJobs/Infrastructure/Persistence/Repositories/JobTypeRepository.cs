namespace Infrastructure.Persistence.Repositories;

public class JobTypeRepository(ApplicationDbContext context) : GenericRepository<JobType, int, ApplicationDbContext>(context), IJobTypeRepository
{
}
