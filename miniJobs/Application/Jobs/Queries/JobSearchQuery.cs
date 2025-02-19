using Application.Common.Models;
using Application.Common.Queries;
using Application.Jobs.Models;
using Domain.Dtos;

namespace Application.Jobs.Queries;

public class JobSearchQuery(JobSearchRequest searchRequest) : QueryBase<SearchResponseBase<JobCardDTO>>
{

    public JobSearchRequest SearchRequest { get; set; } = searchRequest;
}
