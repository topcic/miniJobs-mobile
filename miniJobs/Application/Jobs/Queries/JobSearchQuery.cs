using Application.Common.Models;
using Application.Common.Queries;
using Application.Jobs.Models;
using Domain.Entities;

namespace Application.Jobs.Queries;

public class JobSearchQuery : QueryBase<SearchResponseBase<Job>>
{

    public JobSearchRequest SearchRequest { get; set; }

    public JobSearchQuery(JobSearchRequest searchRequest)
    {
        SearchRequest = searchRequest;
    }
}
