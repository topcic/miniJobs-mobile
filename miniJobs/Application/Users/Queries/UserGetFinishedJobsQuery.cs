using Application.Common.Queries;
using Domain.Dtos;

namespace Application.Users.Queries;

public class UserGetFinishedJobsQuery(int id) : QueryBase<IEnumerable<JobCardDTO>>
{
    public int Id { get; set; } = id;
}