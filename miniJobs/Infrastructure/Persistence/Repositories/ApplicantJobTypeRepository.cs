
using Domain.Entities;

namespace Infrastructure.Persistence.Repositories;

public class ApplicantJobTypeRepository(ApplicationDbContext context) : IApplicantJobTypeRepository
{
    private ApplicationDbContext context = context;
    protected readonly DbSet<ApplicantJobType> dbSet = context.Set<ApplicantJobType>();

    public IEnumerable<JobType> FindAll(int applicantId)
    {
        return dbSet.Where(x => x.ApplicantId == applicantId)
               .Join(context.Set<JobType>(),
                jta => jta.JobTypeId,
                jt => jt.Id,
                (jta, jt) => jt).AsEnumerable();
    }

    public async Task InsertAsync(ApplicantJobType applicantJobType)
    {
        await dbSet.AddAsync(applicantJobType);
        await context.SaveChangesAsync();
    }

    public async Task<ApplicantJobType> TryFindAsync(int applicantId, int jobTypeId)
    {
        return await dbSet.SingleOrDefaultAsync(x => x.JobTypeId == jobTypeId && x.ApplicantId == applicantId);
    }

    public async Task<bool> DeleteAsync(int applicantId, int jobTypeId)
    {
        var applicantJobType = await dbSet
        .FirstOrDefaultAsync(ajt => ajt.ApplicantId == applicantId && ajt.JobTypeId == jobTypeId);

        if (applicantJobType == null)
        {
            return false;
        }

        dbSet.Remove(applicantJobType);
        await context.SaveChangesAsync();

        return true;
    }
}