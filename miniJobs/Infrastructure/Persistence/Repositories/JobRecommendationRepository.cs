using Application.Common.Exceptions;
using AutoMapper;
using Domain.Dtos;

namespace Infrastructure.Persistence.Repositories;

public class JobRecommendationRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<JobRecommendation, int, ApplicationDbContext>(context, mapper), IJobRecommendationRepository
{
    private readonly ApplicationDbContext _context = context;
    public async Task<IEnumerable<User>> GetUsersByMatchingJobRecommendationsAsync(int jobId)
    {
        var job = await _context.Jobs.FirstOrDefaultAsync(j => j.Id == jobId);
        if (job == null) return Enumerable.Empty<User>(); // Return an empty collection if the job doesn't exist

        var matchingUsers = await (from user in _context.Users
                                   join recommendation in _context.JobRecommendations on user.Id equals recommendation.CreatedBy
                                   join recJobType in _context.JobRecommendationJobTypes on recommendation.Id equals recJobType.JobRecommendationId into jobTypeMatches
                                   from recJobType in jobTypeMatches.DefaultIfEmpty()
                                   join recCity in _context.JobRecommendationCities on recommendation.Id equals recCity.JobRecommendationId into cityMatches
                                   from recCity in cityMatches.DefaultIfEmpty()
                                   select new
                                   {
                                       User = user,
                                       RecJobType = recJobType,
                                       RecCity = recCity,
                                       HasJobTypeMatch = (recJobType != null && recJobType.JobTypeId == job.JobTypeId),
                                       HasCityMatch = (recCity != null && recCity.CityId == job.CityId)
                                   })
                                   .GroupBy(x => x.User)
                                   .Where(g => (g.All(u => u.RecJobType == null) && g.Any(u => u.HasCityMatch)) // If user has no job types, check for city match
                                            || (g.All(u => u.RecCity == null) && g.Any(u => u.HasJobTypeMatch)) // If user has no cities, check for job type match
                                            || (g.Any(u => u.HasJobTypeMatch) && g.Any(u => u.HasCityMatch))) // If user has both, check for matches on both
                                   .Select(g => g.Key) // Select the user from the grouping
                                   .Distinct()
                                   .ToListAsync();

        return matchingUsers;
    }


    public async Task<int> PublicCountAsync(Dictionary<string, string> parameters = null)
    {
        var query = context.JobRecommendations.AsQueryable();

        if (parameters != null && parameters.TryGetValue("searchText", out string searchText) && !string.IsNullOrWhiteSpace(searchText))
        {
            query = query.Where(jr => jr.Id.ToString().Contains(searchText));
        }

        return await query.CountAsync();
    }

    public async Task<IEnumerable<JobRecommendationDTO>> PublicFindPaginationAsync(Dictionary<string, string> parameters = null)
    {
        var queryParameters = mapper.Map<QueryParametersDto>(parameters);

        var query = from jr in context.JobRecommendations
                    join createdByUser in context.Users on jr.CreatedBy equals createdByUser.Id into createdByUserGroup
                    from createdByUser in createdByUserGroup.DefaultIfEmpty()
                    join createdByEmployer in context.Employers on jr.CreatedBy equals createdByEmployer.Id into createdByEmployerGroup
                    from createdByEmployer in createdByEmployerGroup.DefaultIfEmpty()
                    select new JobRecommendationDTO
                    {
                        ApplicantFullName = createdByEmployer != null && !string.IsNullOrEmpty(createdByEmployer.Name)
                            ? createdByEmployer.Name
                            : (createdByUser != null ? createdByUser.FirstName + " " + createdByUser.LastName : null),
                        CreatedBy= jr.CreatedBy.Value,
                        Cities = context.JobRecommendationCities.Where(jc => jc.JobRecommendationId == jr.Id).Select(jc => jc.City.Name).ToList(),
                        JobTypes = context.JobRecommendationJobTypes.Where(jt => jt.JobRecommendationId == jr.Id).Select(jt => jt.JobType.Name).ToList()
                    };

        if (!string.IsNullOrEmpty(queryParameters.SearchText))
        {
            query = query.Where(jr => jr.ApplicantFullName.Contains(queryParameters.SearchText));
        }


        query = query.Skip(queryParameters.Offset).Take(queryParameters.Limit);

        return await query.ToListAsync();
    }
}