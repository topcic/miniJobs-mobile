namespace Infrastructure.Persistence.Repositories;

public class SavedJobRepository(ApplicationDbContext context) : GenericRepository<SavedJob, int, ApplicationDbContext>(context), ISavedJobRepository
{
}