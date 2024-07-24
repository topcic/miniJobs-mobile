using Application.Common.Queries;
using Domain.Entities;

namespace Application.Jobs.Queries;

public class JobGetApplicantsQuery : QueryBase<IEnumerable<Applicant>>
{
    public int JobId { get; set; }

    public JobGetApplicantsQuery(int jobId)
    {
        JobId = jobId;
    }
}