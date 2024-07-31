using Application.Common.Queries;
using Domain.Entities;

namespace Application.Jobs.Queries;

public class JobFindAllForEmployerQuery : QueryBase<IEnumerable<Job>>
{
    public int EmployerId { get; set; }
    public JobFindAllForEmployerQuery(int employerId)
    {
        EmployerId = employerId;
    }
}
