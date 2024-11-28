namespace Infrastructure.Persistence.Repositories;

public class JobRecommendationCityRepository(ApplicationDbContext context) : IJobRecommendationCityRepository
{
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
    public async Task DeleteRangeAsync(List<JobRecommendationCity> entites)
    {
        dbSet.RemoveRange(entites);
        await context.SaveChangesAsync();
    }

    public async Task InsertRangeAsync(IEnumerable<JobRecommendationCity> jobRecommendationCities)
    {
        await dbSet.AddRangeAsync(jobRecommendationCities);
        await context.SaveChangesAsync();
    }

    public async Task<IEnumerable<JobRecommendationCity>> FindAllAsync(int jobRecommendationId)
    {
        return await dbSet.Where(x => x.JobRecommendationId == jobRecommendationId).ToListAsync();
    }
}