namespace Infrastructure.Persistence.Repositories;

 public class QuestionRepository(ApplicationDbContext context) : GenericRepository<Question, int, ApplicationDbContext>(context), IQuestionRepository
{
}