using AutoMapper;
using Domain.Dtos;

namespace Infrastructure.Persistence.Repositories;

public class JobApplicationRepository(ApplicationDbContext context, IMapper mapper) : GenericRepository<JobApplication, int, ApplicationDbContext>(context, mapper), IJobApplicationRepository
{
    public async Task<IEnumerable<JobApplication>> FindJobApplicationsWithDetailsAsync(int jobId)
    {
        var jobApplications = from ja in context.JobApplications
                              join j in context.Jobs on ja.JobId equals j.Id
                              join a in context.Applicants on ja.CreatedBy equals a.Id
                              join u in context.Users on a.Id equals u.Id
                              join c in context.Cities on u.CityId equals c.Id into cityGroup
                              from c in cityGroup.DefaultIfEmpty()
                              join r in context.Ratings on new { UserId = u.Id, JobAppId = ja.Id }
                                  equals new { UserId = r.RatedUserId, JobAppId = r.JobApplicationId } into ratingGroup
                              from r in ratingGroup.DefaultIfEmpty()
                              where j.Id == jobId
                              select new JobApplication
                              {
                                  Id = ja.Id,
                                  JobId = ja.JobId,
                                  Status = ja.Status,
                                  IsDeleted = ja.IsDeleted,
                                  CreatedByName = u.FirstName + " " + u.LastName,
                                  HasRated = context.Ratings.Any(r => r.RatedUserId == u.Id && r.JobApplicationId == ja.Id),
                                  Rating = r 
                              };

        return await jobApplications.ToListAsync();
    }

    public async Task<IEnumerable<JobApplication>> GetJobApplicationForReportsAsync()
    {
        var jobApplications = from ja in context.JobApplications
                              join j in context.Jobs on ja.JobId equals j.Id
                              join jt in context.JobTypes on j.JobTypeId equals jt.Id into jobTypeJoin
                              from jt in jobTypeJoin.DefaultIfEmpty()
                              join a in context.Applicants on ja.CreatedBy equals a.Id
                              join u in context.Users on a.Id equals u.Id
                              join c in context.Cities on u.CityId equals c.Id into cityGroup
                              from c in cityGroup.DefaultIfEmpty()
                              join r in context.Ratings on new { UserId = u.Id, JobAppId = ja.Id }
                                  equals new { UserId = r.RatedUserId, JobAppId = r.JobApplicationId } into ratingGroup
                              from r in ratingGroup.DefaultIfEmpty()
                              join createdByUser in context.Users on r.CreatedBy equals createdByUser.Id into createdByUserGroup
                              from createdByUser in createdByUserGroup.DefaultIfEmpty()
                              join ratedUser in context.Users on r.RatedUserId equals ratedUser.Id into ratedUserGroup
                              from ratedUser in ratedUserGroup.DefaultIfEmpty()
                              join createdByUserRole in context.UserRoles on createdByUser.Id equals createdByUserRole.UserId into createdByUserRoleGroup
                              from createdByUserRole in createdByUserRoleGroup.DefaultIfEmpty()
                              join ratedUserRole in context.UserRoles on ratedUser.Id equals ratedUserRole.UserId into ratedUserRoleGroup
                              from ratedUserRole in ratedUserRoleGroup.DefaultIfEmpty()
                              select new JobApplication
                              {
                                  Id = ja.Id,
                                  JobId = ja.JobId,
                                  Status = ja.Status,
                                  IsDeleted = ja.IsDeleted,
                                  CreatedByName = u.FirstName + " " + u.LastName,
                                  HasRated = context.Ratings.Any(r => r.RatedUserId == u.Id && r.JobApplicationId == ja.Id),
                                  Rating = r != null ? new Rating
                                  {
                                      Id = r.Id,
                                      Value = r.Value,
                                      Comment = r.Comment,
                                      JobApplicationId = r.JobApplicationId,
                                      RatedUserId = r.RatedUserId,
                                      IsActive = r.IsActive,
                                      CreatedByFullName = createdByUser != null ? createdByUser.FirstName + " " + createdByUser.LastName : null,
                                      RatedUserFullName = ratedUser != null ? ratedUser.FirstName + " " + ratedUser.LastName : null,
                                      CreatedByRole = createdByUserRole != null ? createdByUserRole.RoleId : null,
                                      RatedUserRole = ratedUserRole != null ? ratedUserRole.RoleId : null,
                                      Created=r.Created,
                                      CreatedBy=r.CreatedBy,
                                      LastModified=r.LastModified,
                                      LastModifiedBy=r.LastModifiedBy,
                                  } : null,
                                  Job = new Job
                                  {
                                      Id = j.Id,
                                      Name = j.Name,
                                      Description = j.Description,
                                      StreetAddressAndNumber = j.StreetAddressAndNumber,
                                      ApplicationsDuration = j.ApplicationsDuration,
                                      Status = j.Status,
                                      RequiredEmployees = j.RequiredEmployees,
                                      Wage = j.Wage,
                                      CityId = j.CityId,
                                      JobTypeId = j.JobTypeId,
                                      Created = j.Created,
                                      CreatedBy = j.CreatedBy,
                                      JobType = jt, // Mapping JobType
                                      City = c      // Mapping City
                                  }
                              };

        return await jobApplications.ToListAsync();
    }

    public async override Task<int> CountAsync(Dictionary<string, string> parameters = null)
    {
        var query = context.JobApplications.AsQueryable();

        if (parameters != null && parameters.TryGetValue("searchText", out string searchText) && !string.IsNullOrWhiteSpace(searchText))
        {
            query = query.Where(ja =>
               ja.JobReference.Name.ToString().Contains(searchText) ||
               ja.User.FirstName.Contains(searchText) ||
               ja.User.LastName.Contains(searchText)
           );
        }


        var count = await query.CountAsync();
        return count;
    }
    public async override Task<IEnumerable<JobApplication>> FindPaginationAsync(Dictionary<string, string> parameters = null)
    {
        var queryParameters = mapper.Map<QueryParametersDto>(parameters);

        var query = from ja in context.JobApplications
                    join u in context.Users on ja.CreatedBy equals u.Id into userGroup
                    from u in userGroup.DefaultIfEmpty()
                    join j in context.Jobs on ja.JobId equals j.Id into jobGroup
                    from j in jobGroup.DefaultIfEmpty()
                    where !ja.IsDeleted 
                    select new JobApplication
                    {
                        Id = ja.Id,
                        JobId = ja.JobId,
                        Status = ja.Status,
                        Created = ja.Created,
                        CreatedBy=ja.CreatedBy,
                        IsDeleted = ja.IsDeleted,
                        CreatedByName = u != null ? (u.FirstName + " " + u.LastName) : null,
                        JobName = j != null ? j.Name : null
                    };

        if (!string.IsNullOrEmpty(queryParameters.SearchText))
        {
            query = query.Where(ja => ja.JobName.Contains(queryParameters.SearchText) ||
                                      ja.CreatedByName.Contains(queryParameters.SearchText));
        }

        query = query.Skip(queryParameters.Offset).Take(queryParameters.Limit);

        return await query.ToListAsync();
    }
}