using Domain.Dtos;
using Domain.Entities;

namespace Domain.Interfaces;

public interface IJobRepository : IGenericRepository<Job, int>
{
    Task<Job> GetWithDetailsAsync(int id,bool isApplicant, int userId=0);
    Task<IEnumerable<Job>> GetEmployerJobsAsync(int employeerId);
    Task<IEnumerable<Job>> SearchAsync(string searchText, int limit, int offset, int? cityId, int? jobTypeId);
    Task<int> SearchCountAsync(string searchText, int? cityId, int? jobTypeId);
    Task<IEnumerable<Job>> GetApplicantSavedJobsAsync(int applicantId);
    Task<IEnumerable<Job>> GetApplicantAppliedJobsAsync(int applicantId);
    Task<IEnumerable<ApplicantDTO>> GetApplicants(int jobId);
}