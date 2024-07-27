using Application.Applicants.Models;
using Application.Common.Queries;
using Domain.Dtos;
using Domain.Entities;

namespace Application.Jobs.Queries;

public class JobGetApplicantsQuery : QueryBase<IEnumerable<ApplicantDTO>>
{
    public int JobId { get; set; }

    public JobGetApplicantsQuery(int jobId)
    {
        JobId = jobId;
    }
}