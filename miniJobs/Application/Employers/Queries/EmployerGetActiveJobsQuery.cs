using Application.Common.Queries;
using Domain.Entities;

namespace Application.Employers.Queries;

public class EmployerGetActiveJobsQuery(int employerId) : QueryBase<IEnumerable<Job>>
{
    public int EmployerId { get; set; } = employerId;
}