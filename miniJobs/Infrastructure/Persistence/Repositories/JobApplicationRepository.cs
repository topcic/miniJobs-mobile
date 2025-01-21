using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class JobApplicationRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<JobApplication, int, ApplicationDbContext>(context, mapper), IJobApplicationRepository
{
}