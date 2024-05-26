using Application.Common.Queries;
using Domain.Entities;

namespace Application.Jobs.Queries;

public class JobTryFindQuery : QueryBase<Job>
{
    public int JobId { get; set; }

    public JobTryFindQuery(int jobId)
    {
        JobId = jobId;
    }
}