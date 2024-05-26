using Domain.Entities;

namespace Domain.Interfaces;

public interface IJobRepository : IGenericRepository<Job, int>
{
    Task<Job> GetWithDetailsAsync(int id);

    Task<IEnumerable<Job>> GetEmployeerJobsAsync(int employeerId);
}