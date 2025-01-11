using Application.Common.Queries;
using Domain.Dtos;

namespace Application.Applicants.Queries;
public class ApplicantTryFindQuery(int id) : QueryBase<ApplicantDTO>
{
    public int Id { get; set; } = id;
}