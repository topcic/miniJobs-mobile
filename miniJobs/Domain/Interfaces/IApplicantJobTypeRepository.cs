using Domain.Entities;

namespace Domain.Interfaces;

public interface IApplicantJobTypeRepository
{
    Task InsertAsync(ApplicantJobType applicantJobType);
    Task<bool> DeleteAsync(ApplicantJobType applicantJobType);
    IEnumerable<JobType> FindAll(int applicantId);
    Task<ApplicantJobType> TryFindAsync(int applicantId, int jobTypeId);
}