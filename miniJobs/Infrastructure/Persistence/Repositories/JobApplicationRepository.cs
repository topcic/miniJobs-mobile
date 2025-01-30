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
}