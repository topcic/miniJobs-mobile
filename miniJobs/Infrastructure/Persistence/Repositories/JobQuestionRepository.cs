namespace Infrastructure.Persistence.Repositories;

public class JobQuestionRepository(ApplicationDbContext context) : GenericRepository<JobQuestion, int, ApplicationDbContext>(context), IJobQuestionRepository
{
}