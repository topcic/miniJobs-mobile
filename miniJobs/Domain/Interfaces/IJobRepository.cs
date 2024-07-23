using Domain.Entities;

namespace Domain.Interfaces;

public interface IJobRepository : IGenericRepository<Job, int>
{
    Task<Job> GetWithDetailsAsync(int id,bool isApplicant, int userId=0);

    Task<IEnumerable<Job>> GetEmployeerJobsAsync(int employeerId);

    Task<IEnumerable<Job>> SearchAsync(string searchText, int limit, int offset, int? cityId, int? jobTypeId);
    Task<int> SearchCountAsync(string searchText, int? cityId, int? jobTypeId);
}