using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class QuestionThreadRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<QuestionThread, int, ApplicationDbContext>(context, mapper), IQuestionThreadRepository
{
}