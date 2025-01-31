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
}