using Application.Common.Context;
using MediatR;

namespace Application.Common.Queries;

public abstract class QueryBase<TResult> : IRequest<TResult> where TResult : class
{
    /// <summary>
    /// User id
    /// </summary>
    public int? UserId
    {
        get
        {
            return UserContext.GetUserId();
        }
    }

    /// <summary>
    /// Role id
    /// </summary>
    public string RoleId
    {
        get
        {
            return UserContext.GetRoleId();
        }


    }
}