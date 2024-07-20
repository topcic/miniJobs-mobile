

using Microsoft.Data.SqlClient;

namespace Infrastructure.Persistence.Repositories;

public class ApplicantRepository(ApplicationDbContext context) : GenericRepository<Applicant, int, ApplicationDbContext>(context), IApplicantRepository
{
    private readonly ApplicationDbContext _context= context;

    public async Task<IEnumerable<Applicant>> SearchAsync(string searchText, int limit, int offset, int? cityId, int? jobTypeId)
    {
        var query = context.Applicants.AsQueryable();

        if (!string.IsNullOrEmpty(searchText))
        {
            query = query.Where(a =>
                (a.User.LastName != null && a.User.LastName.Contains(searchText)) ||
                (a.User.FirstName != null && a.User.FirstName.Contains(searchText))
            );
        }

        if (cityId.HasValue)
        {
            query = query.Where(a => a.User.CityId == cityId.Value);
        }

        if (jobTypeId.HasValue)
        {
            query = query.Where(a => a.ApplicantJobTypes.Any(ajt => ajt.JobTypeId == jobTypeId.Value));
        }

        query = query.Skip(offset).Take(limit);

        query = query.Include(a => a.User)
            .Include(a=>a.User.City)
                     .Include(a => a.ApplicantJobTypes).ThenInclude(ajt => ajt.JobType);

        var result = await query.ToListAsync();

        return result;
    }

    public async Task<int> SearchCountAsync(string searchText, int? cityId, int? jobTypeId)
    {
        var query = context.Applicants.AsQueryable();
        if (!string.IsNullOrEmpty(searchText))
        {
            query = query.Where(a =>
                (a.User.LastName != null && a.User.LastName.Contains(searchText)) ||
                (a.User.FirstName != null && a.User.FirstName.Contains(searchText))
            );
        }
        if (cityId.HasValue)
        {
            query = query.Where(a => a.User.CityId == cityId.Value);
        }
        if (jobTypeId.HasValue)
        {
            query = query.Where(a => a.ApplicantJobTypes.Any(ajt => ajt.JobTypeId == jobTypeId.Value));
        }

        var count = await query.CountAsync();

        return count;
    }
}