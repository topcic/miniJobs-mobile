using Domain.Dtos;
using Domain.Entities;

namespace Domain.Interfaces;
public interface IEmployerRepository : IGenericRepository<Employer, int>
{
    Task<EmployerDTO> GetWithDetailsAsync(int id);
    Task<IEnumerable<Job>> GetActiveJobs(int userId, int requestedBy);
}