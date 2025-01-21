using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class SavedJobRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<SavedJob, int, ApplicationDbContext>(context, mapper), ISavedJobRepository
{
}