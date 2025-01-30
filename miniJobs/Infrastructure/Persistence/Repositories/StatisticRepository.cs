using Domain.Dtos;
using Domain.Enums;

namespace Infrastructure.Persistence.Repositories;

public class StatisticRepository(ApplicationDbContext context) : IStatisticRepository
{
    public async Task<OverallStatisticDto?> GetOverallStatisticsAsync()
    {
        var totalApplicants = await context.Applicants.CountAsync();
        var totalEmployers = await context.Employers.CountAsync();
        var totalJobs = await context.Jobs.CountAsync();
        var totalActiveJobs = await context.Jobs
            .Where(j => j.Status == JobStatus.Active && !j.DeletedByAdmin)
            .CountAsync();

        var employerRatings = await (
      from r in context.Ratings
      join u in context.Users on r.RatedUserId equals u.Id
      join ur in context.UserRoles on u.Id equals ur.UserId  // Join with user_roles table
      where ur.RoleId == "Employer" && r.IsActive
      select (double?)r.Value
  ).ToListAsync();

        double averageEmployerRating = employerRatings.Any() ? employerRatings.Average() ?? 0 : 0;

        // Fetch applicant ratings
        var applicantRatings = await (
            from r in context.Ratings
            join u in context.Users on r.RatedUserId equals u.Id
            join ur in context.UserRoles on u.Id equals ur.UserId  // Join with user_roles table
            where ur.RoleId == "Applicant" && r.IsActive
            select (double?)r.Value
        ).ToListAsync();

        double averageApplicantRating = applicantRatings.Any() ? applicantRatings.Average() ?? 0 : 0;


        return new OverallStatisticDto
        {
            TotalApplicants = totalApplicants,
            TotalEmployers = totalEmployers,
            TotalJobs = totalJobs,
            TotalActiveJobs = totalActiveJobs,
            AverageEmployerRating = Math.Round(averageEmployerRating, 2),
            AverageApplicantRating = Math.Round(averageApplicantRating, 2)
        };
    }


}
