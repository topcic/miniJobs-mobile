using Domain.Entities;

namespace Domain.Interfaces;

public interface IApplicantJobTypeRepository
{
    Task InsertAsync(ApplicantJobType applicantJobType);
    Task<bool> DeleteAsync(int applicantId, int jobTypeId);
    IEnumerable<JobType> FindAll(int applicantId);
    Task<ApplicantJobType> TryFindAsync(int applicantId, int jobTypeId);
}