namespace Infrastructure.Persistence.Repositories;

public class JobTypeAssignmentRepository(ApplicationDbContext context) : IJobTypeAssignmentRepository
{
    private ApplicationDbContext context = context;
    protected readonly DbSet<JobTypeAssignment> dbSet = context.Set<JobTypeAssignment>();

    public async Task<bool> DeleteAsync(JobTypeAssignment JobTypeAssignment)
    {
        dbSet.Remove(JobTypeAssignment);
        await context.SaveChangesAsync();
        return true;
    }

    public IEnumerable<JobType> FindAll(int jobId)
    {
        return dbSet.Where(x => x.JobId == jobId)
               .Join(context.Set<JobType>(),
                jta => jta.JobTypeId,
                jt => jt.Id,
                (jta, jt) => jt).AsEnumerable();
    }

    public async Task InsertAsync(JobTypeAssignment jobTypeAssignment)
    {
        await dbSet.AddAsync(jobTypeAssignment);
        await context.SaveChangesAsync();
    }

    public async Task<JobTypeAssignment> TryFindAsync(int jobId, int jobTypeId)
    {
        return await dbSet.SingleOrDefaultAsync(x => x.JobTypeId == jobTypeId && x.JobId == jobId);
    }
}