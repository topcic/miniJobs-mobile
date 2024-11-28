namespace Infrastructure.Persistence.Repositories;

public class JobRecommendationJobTypeRepository(ApplicationDbContext context) : IJobRecommendationJobTypeRepository
{
    protected readonly DbSet<JobRecommendationJobType> dbSet = context.Set<JobRecommendationJobType>();

    public async Task<IEnumerable<JobRecommendationJobType>> FindAllAsync(int jobRecommendationId)
    {
        return await dbSet.Where(x => x.JobRecommendationId == jobRecommendationId).ToListAsync();
    }

    public async Task InsertAsync(JobRecommendationJobType jobRecommendationJobType)
    {
        await dbSet.AddAsync(jobRecommendationJobType);
        await context.SaveChangesAsync();
    }

    public async Task<JobRecommendationJobType> TryFindAsync(int jobRecommendationId, int jobTypeId)
    {
        return await dbSet.SingleOrDefaultAsync(x => x.JobTypeId == jobTypeId && x.JobRecommendationId == jobRecommendationId);
    }

    public async Task<bool> DeleteAsync(int jobRecommendationId, int jobTypeId)
    {
        var entity = await dbSet
        .FirstOrDefaultAsync(x => x.JobTypeId == jobTypeId && x.JobRecommendationId == jobRecommendationId);

        if (entity == null)
        {
            return false;
        }

        dbSet.Remove(entity);
        await context.SaveChangesAsync();

        return true;
    }

    public async Task InsertRangeAsync(IEnumerable<JobRecommendationJobType> jobRecommendationJobTypes)
    {
        await dbSet.AddRangeAsync(jobRecommendationJobTypes);
        await context.SaveChangesAsync();
    }

    public async Task DeleteRangeAsync(List<JobRecommendationJobType> entites)
    {
        dbSet.RemoveRange(entites);
        await context.SaveChangesAsync();
    }
}