using AutoMapper;

namespace Infrastructure.Persistence.Repositories;

public class JobRecommendationRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<JobRecommendation, int, ApplicationDbContext>(context, mapper), IJobRecommendationRepository
{
    private readonly ApplicationDbContext _context = context;
    public async Task<IEnumerable<User>> GetUsersByMatchingJobRecommendationsAsync(int jobId)
    {
        var job = await _context.Jobs.FirstOrDefaultAsync(j => j.Id == jobId);


        var matchingUsers = await (from user in _context.Users
                                   join recommendation in _context.JobRecommendations on user.Id equals recommendation.CreatedBy
                                   join recJobType in _context.JobRecommendationJobTypes on recommendation.Id equals recJobType.JobRecommendationId into jobTypeMatches
                                   from recJobType in jobTypeMatches.DefaultIfEmpty()
                                   join recCity in _context.JobRecommendationCities on recommendation.Id equals recCity.JobRecommendationId into cityMatches
                                   from recCity in cityMatches.DefaultIfEmpty()
                                   where (recJobType != null && recJobType.JobTypeId == job.JobTypeId)
                                      || (recCity != null && recCity.CityId == job.CityId)
                                   select user)
                                   .Distinct()
                                   .ToListAsync();

        return matchingUsers;
    }
}