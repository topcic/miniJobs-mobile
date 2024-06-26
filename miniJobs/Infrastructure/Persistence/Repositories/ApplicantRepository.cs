﻿

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
        //    var searchTextParam = new SqlParameter("@searchText", string.IsNullOrEmpty(searchText) ? (object)DBNull.Value : $"%{searchText}%");
        //    var cityIdParam = new SqlParameter("@cityId", cityId.HasValue ? (object)cityId.Value : DBNull.Value);
        //    var jobTypeIdParam = new SqlParameter("@jobTypeId", jobTypeId.HasValue ? (object)jobTypeId.Value : DBNull.Value);
        //    var offsetParam = new SqlParameter("@offset", offset);
        //    var limitParam = new SqlParameter("@limit", limit);

        //    var query = _context.Applicants
        //.Include(a => a.User)
        //.Include(a => a.ApplicantJobTypes)
        //    .ThenInclude(ajt => ajt.JobType)
        //.Where(a => !a.User.Deleted &&
        //    (searchText == null || (a.User.FirstName.Contains(searchText) || a.User.LastName.Contains(searchText))) &&
        //    (!cityId.HasValue || a.User.CityId == cityId) &&
        //    (!jobTypeId.HasValue || a.ApplicantJobTypes.Any(ajt => ajt.JobTypeId == jobTypeId)))
        //.OrderBy(a => a.User.LastName)
        //.Skip(offset)
        //.Take(limit);

        //    var resultList = await query.ToListAsync();

        //    return resultList;
        var query = context.Applicants.AsQueryable();

        // Filter by search text
        if (!string.IsNullOrEmpty(searchText))
        {
            query = query.Where(a =>
                (a.User.LastName != null && a.User.LastName.Contains(searchText)) ||
                (a.User.FirstName != null && a.User.FirstName.Contains(searchText))
            );
        }

        // Filter by city ID
        if (cityId.HasValue)
        {
            query = query.Where(a => a.User.CityId == cityId.Value);
        }

        // Filter by job type ID
        if (jobTypeId.HasValue)
        {
            query = query.Where(a => a.ApplicantJobTypes.Any(ajt => ajt.JobTypeId == jobTypeId.Value));
        }

        // Apply pagination
        query = query.Skip(offset).Take(limit);

        // Include related entities
        query = query.Include(a => a.User)
                     .Include(a => a.ApplicantJobTypes).ThenInclude(ajt => ajt.JobType);

        // Execute the query
        var result = await query.ToListAsync();

        return result;


    }

    public async Task<int> SearchCountAsync(string searchText, int? cityId, int? jobTypeId)
    {
        // Start the query
        var query = context.Applicants.AsQueryable();

        // Filter by search text
        if (!string.IsNullOrEmpty(searchText))
        {
            query = query.Where(a =>
                (a.User.LastName != null && a.User.LastName.Contains(searchText)) ||
                (a.User.FirstName != null && a.User.FirstName.Contains(searchText))
            );
        }

        // Filter by city ID
        if (cityId.HasValue)
        {
            query = query.Where(a => a.User.CityId == cityId.Value);
        }

        // Filter by job type ID
        if (jobTypeId.HasValue)
        {
            query = query.Where(a => a.ApplicantJobTypes.Any(ajt => ajt.JobTypeId == jobTypeId.Value));
        }

        // Get the count
        var count = await query.CountAsync();

        return count;
    }
}