using Application.Common.Commands;
using Domain.Entities;

namespace Application.Users.Commands;
public class UserDeleteCommand(int deleteUserId) : CommandBase<User>
{
    public int DeleteUserId { get; set; } = deleteUserId;
}