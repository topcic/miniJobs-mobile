using Application.Common.Queries;
using Domain.Dtos;

namespace Application.Employers.Queries;

public class EmployerGetActiveJobsQuery(int employerId) : QueryBase<IEnumerable<JobCardDTO>>
{
    public int EmployerId { get; set; } = employerId;
}