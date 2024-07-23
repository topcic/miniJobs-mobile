using Domain.Entities;

namespace Domain.Interfaces;
public interface IEmployerRepository : IGenericRepository<Employer, int>
{
    Task<Employer> GetWithDetailsAsync(int id);
    Task<IEnumerable<Job>> GetActiveJobs(int userId, int requestedBy);
}