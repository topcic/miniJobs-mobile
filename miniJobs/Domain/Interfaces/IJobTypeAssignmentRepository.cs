using Domain.Entities;

namespace Domain.Interfaces;

public interface IJobTypeAssignmentRepository
{
    Task InsertAsync(JobTypeAssignment jobTypeAssignment);
    Task<bool> DeleteAsync(JobTypeAssignment JobTypeAssignment);
    IEnumerable<JobType> FindAll(int jobId);
    Task<JobTypeAssignment> TryFindAsync(int jobId, int jobTypeId);
}