using Domain.Entities;

namespace Infrastructure.Persistence.Repositories;

public class JobRecommendationCityRepository(ApplicationDbContext context) : IJobRecommendationCityRepository
{
    private ApplicationDbContext context = context;
    protected readonly DbSet<JobRecommendationCity> dbSet = context.Set<JobRecommendationCity>();

    public async Task<JobRecommendationCity> TryFindAsync(int jobRecommendationId, int cityId)
    {
        return await dbSet.SingleOrDefaultAsync(x => x.CityId == cityId && x.JobRecommendationId == jobRecommendationId);
    }

    public async Task<bool> DeleteAsync(int jobRecommendationId, int cityId)
    {
        var entity = await dbSet
        .FirstOrDefaultAsync(x => x.CityId == cityId && x.JobRecommendationId == jobRecommendationId);

        if (entity == null)
        {
            return false;
        }

        dbSet.Remove(entity);
        await context.SaveChangesAsync();

        return true;
    }

    public async Task InsertRangeAsync(IEnumerable<JobRecommendationCity> jobRecommendationCities)
    {
        await dbSet.AddRangeAsync(jobRecommendationCities);
        await context.SaveChangesAsync();
    }

    public async Task<IEnumerable<City>> FindAllAsync(int jobRecommendationId)
    {
        return await dbSet.Where(x => x.JobRecommendationId == jobRecommendationId)
                 .Join(context.Set<City>(),
                      jrc => jrc.CityId,
                      c => c.Id,
                      (jrc, c) => c)
                 .ToListAsync();
    }
}