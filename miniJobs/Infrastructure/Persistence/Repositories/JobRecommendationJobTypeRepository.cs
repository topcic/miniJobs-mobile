namespace Infrastructure.Persistence.Repositories;

internal class JobRecommendationJobTypeRepository(ApplicationDbContext context) : IJobRecommendationJobTypeRepository
{
    private ApplicationDbContext context = context;
    protected readonly DbSet<JobRecommendationJobType> dbSet = context.Set<JobRecommendationJobType>();

    public async Task<IEnumerable<JobType>> FindAllAsync(int jobRecommendationId)
    {
        return await dbSet.Where(x => x.JobRecommendationId == jobRecommendationId)
               .Join(context.Set<JobType>(),
                jrjt => jrjt.JobTypeId,
                jt => jt.Id,
                (jrjt, jt) => jt).ToListAsync();
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
}