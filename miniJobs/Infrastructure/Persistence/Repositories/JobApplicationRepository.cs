namespace Infrastructure.Persistence.Repositories;

public class JobApplicationRepository(ApplicationDbContext context) : GenericRepository<JobApplication, int, ApplicationDbContext>(context), IJobApplicationRepository
{
}