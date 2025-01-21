using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class JobTypeRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<JobType, int, ApplicationDbContext>(context, mapper), IJobTypeRepository
{
}
