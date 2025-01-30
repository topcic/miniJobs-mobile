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
        var averageEmployerRating = await (
            from r in context.Ratings
            join u in context.Users on r.RatedUserId equals u.Id
            where u.Role == "Employer" && r.IsActive
            select r.Value
        ).DefaultIfEmpty(0).AverageAsync();

        var averageApplicantRating = await (
            from r in context.Ratings
            join u in context.Users on r.RatedUserId equals u.Id
            where u.Role == "Applicant" && r.IsActive
            select r.Value
        ).DefaultIfEmpty(0).AverageAsync();

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
