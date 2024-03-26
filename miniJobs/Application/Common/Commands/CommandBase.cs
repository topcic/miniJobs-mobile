using Application.Common.Context;
using MediatR;

namespace Application.Common.Commands;
/// <summary>
/// This is the base class from which command objects will be derived.
/// </summary>
/// <typeparam name="T">The actual type descending from CommandBase, 
/// used to generate type-correct methods in this base class.</typeparam>
public class CommandBase<T> : IRequest<T>
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

    /// <summary>
    /// User id string
    /// </summary>
    public string UserIdString
    {
        get
        {
            return UserId.HasValue ? UserId.ToString() : null;
        }
    }
}