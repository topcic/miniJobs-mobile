using Domain.Dtos;
using Domain.Entities;
using Domain.Enums;

namespace Domain.Interfaces;

public interface IJobRepository : IGenericRepository<Job, int>
{
    Task<Job> GetWithDetailsAsync(int id,bool isApplicant, int userId=0);
    Task<IEnumerable<Job>> GetEmployerJobsAsync(int employeerId);
    Task<IEnumerable<Job>> SearchAsync(string searchText, int limit, int offset, int? cityId, SortOrder sort);
    Task<int> SearchCountAsync(string searchText, int? cityId);
    Task<IEnumerable<Job>> GetApplicantSavedJobsAsync(int applicantId);
    Task<IEnumerable<JobApplication>> GetApplicantAppliedJobsAsync(int applicantId);
    Task<IEnumerable<ApplicantDTO>> GetApplicants(int jobId,string role);
    Task<IEnumerable<Job>> GetJobsExpiringInTwoDaysAsync();
    Task<IEnumerable<Job>> GetExpiredActiveJobsAsync();

    Task<int> PublicCountAsync(Dictionary<string, string> parameters = null);
    Task<IEnumerable<JobDTO>> PublicFindPaginationAsync(Dictionary<string, string> parameters = null);

    Task<IEnumerable<Job>> GetJobsForReportsAsync();

}