using Application.Common.Queries;
using Domain.Entities;

namespace Application.Users.Queries;

public class UserGetFinishedJobsQuery : QueryBase<IEnumerable<Job>>
{
    public int Id { get; set; }

    public UserGetFinishedJobsQuery(int id)
    {
        Id = id;
    }
}