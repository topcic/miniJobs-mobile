

using Microsoft.Data.SqlClient;

namespace Infrastructure.Persistence.Repositories;

public class ApplicantRepository(ApplicationDbContext context) : GenericRepository<Applicant, int, ApplicationDbContext>(context), IApplicantRepository
{
    private readonly ApplicationDbContext _context= context;

    public async Task<IEnumerable<Applicant>> SearchAsync(string searchText, int limit, int offset, int? cityId, int? jobTypeId)
    {
        //var query = _context.Applicants
        //            .Include(a => a.User)
        //            .Include(a => a.ApplicantJobTypes)
        //            .ThenInclude(ajt => ajt.JobType)
        //            .Where(a => a.User.Deleted == false);

        //if (!string.IsNullOrEmpty(searchText))
        //{
        //    query = query.Where(a =>
        //        a.User.FirstName.Contains(searchText) ||
        //        a.User.LastName.Contains(searchText));
        //}

        //if (cityId.HasValue)
        //{
        //    query = query.Where(a => a.User.CityId == cityId);
        //}

        //if (jobTypeId.HasValue)
        //{
        //    query = query.Where(a => a.ApplicantJobTypes.Any(ajt => ajt.JobTypeId == jobTypeId));
        //}

        //return await query
        //             .OrderBy(a => a.User.LastName)
        //             .Skip(offset)
        //             .Take(limit)
        //             .ToListAsync();
        var searchTextParam = new SqlParameter("@searchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : $"%{searchText}%");
        var cityIdParam = new SqlParameter("@cityId", cityId.HasValue ? (object)cityId.Value : DBNull.Value);
        var jobTypeIdParam = new SqlParameter("@jobTypeId", jobTypeId.HasValue ? (object)jobTypeId.Value : DBNull.Value);
        var offsetParam = new SqlParameter("@offset", offset);
        var limitParam = new SqlParameter("@limit", limit);

        var query =await _context.Applicants
            .FromSqlRaw(@"
     SELECT 
    a.id AS Id, 
    a.cv AS Cv, 
    a.experience AS Experience, 
    a.description AS Description, 
    a.created AS Created, 
    u.id AS UserId, 
    u.Deleted AS UserDeleted, 
    u.last_name AS UserLastName
FROM 
    applicants a
INNER JOIN 
    users u ON a.id = u.id
WHERE 
    u.Deleted = 0
ORDER BY 
    u.last_name
OFFSET 
    @offset ROWS
FETCH NEXT 
    @limit ROWS ONLY",
                searchTextParam,  offsetParam, limitParam)
            .Include(a => a.User)
            .ToListAsync();
        return query;
    }

    public async Task<int> SearchCountAsync(string searchText, int? cityId, int? jobTypeId)
    {
        var query = _context.Applicants
                        .Include(a => a.User)
                        .Include(a => a.ApplicantJobTypes)
                        .ThenInclude(ajt => ajt.JobType)
                        .Where(a => a.User.Deleted == false);

        if (!string.IsNullOrEmpty(searchText))
        {
            query = query.Where(a =>
                a.User.FirstName.Contains(searchText) ||
                a.User.LastName.Contains(searchText) ||
                a.Experience.Contains(searchText) ||
                a.Description.Contains(searchText));
        }

        if (cityId.HasValue)
        {
            query = query.Where(a => a.User.CityId == cityId);
        }

        if (jobTypeId.HasValue)
        {
            query = query.Where(a => a.ApplicantJobTypes.Any(ajt => ajt.JobTypeId == jobTypeId));
        }

        return await query.CountAsync();
    }
}