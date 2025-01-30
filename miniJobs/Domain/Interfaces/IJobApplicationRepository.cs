using Domain.Entities;

namespace Domain.Interfaces;

public interface IJobApplicationRepository : IGenericRepository<JobApplication, int>
{
    Task<IEnumerable<JobApplication>> FindJobApplicationsWithDetailsAsync(int jobId);
}