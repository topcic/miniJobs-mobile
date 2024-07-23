using Application.Common.Queries;
using Domain.Entities;

namespace Application.Employers.Queries;

public class EmployerGetActiveJobsQuery : QueryBase<IEnumerable<Job>>
{
    public int EmployerId { get; set; }

    public EmployerGetActiveJobsQuery(int employerId)
    {
        EmployerId = employerId;
    }
}