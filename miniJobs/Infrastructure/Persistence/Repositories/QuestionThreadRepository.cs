namespace Infrastructure.Persistence.Repositories;

public class QuestionThreadRepository(ApplicationDbContext context) : GenericRepository<QuestionThread, int, ApplicationDbContext>(context), IQuestionThreadRepository
{
}