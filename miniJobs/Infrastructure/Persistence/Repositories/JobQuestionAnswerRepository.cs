namespace Infrastructure.Persistence.Repositories;

public class JobQuestionAnswerRepository(ApplicationDbContext context) : GenericRepository<JobQuestionAnswer, int, ApplicationDbContext>(context), IJobQuestionAnswerRepository
{
}