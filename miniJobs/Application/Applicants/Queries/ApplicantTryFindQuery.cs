using Application.Common.Queries;
using Domain.Dtos;

namespace Application.Applicants.Queries;
public class ApplicantTryFindQuery : QueryBase<ApplicantDTO>
{
    public int Id { get; set; }

    public ApplicantTryFindQuery(int id)
    {
        Id = id;
    }
}