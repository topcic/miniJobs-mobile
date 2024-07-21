using Application.Common.Queries;
using Domain.Entities;

namespace Application.Users;

public class UserGetRatingsQuery : QueryBase<IEnumerable<Rating>>
{
    public int Id { get; set; }

    public UserGetRatingsQuery(int id)
    {
        Id = id;
    }
}
