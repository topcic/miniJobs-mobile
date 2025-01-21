using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class JobQuestionAnswerRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<JobQuestionAnswer, int, ApplicationDbContext>(context, mapper), IJobQuestionAnswerRepository
{
}