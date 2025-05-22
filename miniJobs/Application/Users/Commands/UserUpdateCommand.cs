using Application.Common.Commands;
using Domain.Entities;

namespace Application.Users.Commands;

public class UserUpdateCommand(User user) : CommandBase<User>
{
    public User User { get; set; } = user;
}