namespace Infrastructure.Persistence.Repositories;

public class JobRecommendationRepository(ApplicationDbContext context) : GenericRepository<JobRecommendation, int, ApplicationDbContext>(context), IJobRecommendationRepository
{
    private readonly ApplicationDbContext _context = context;
}