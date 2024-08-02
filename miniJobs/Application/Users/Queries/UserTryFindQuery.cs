using Application.Common.Queries;
using Domain.Entities;

namespace Application.Users.Queries;

public class UserTryFindQuery : QueryBase<User>
{
    public int Id { get; set; }

    public UserTryFindQuery(int id)
    {
        Id = id;
    }
}