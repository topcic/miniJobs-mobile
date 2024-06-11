using Application.Applicants.Models;
using Application.Common.Models;
using Application.Common.Queries;
using Domain.Entities;

namespace Application.Applicants.Queries;

public class ApplicantSearchAsyncQuery : QueryBase<SearchResponseBase<Applicant>>
{
   
    public ApplicantSearchRequest SearchRequest { get; set; }
    
    public ApplicantSearchAsyncQuery(ApplicantSearchRequest searchRequest)
    {
        SearchRequest = searchRequest;
    }
}
