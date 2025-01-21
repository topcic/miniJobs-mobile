using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class JobQuestionRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<JobQuestion, int, ApplicationDbContext>(context, mapper), IJobQuestionRepository
{
}