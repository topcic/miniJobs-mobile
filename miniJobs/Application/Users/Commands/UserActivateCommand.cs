using Application.Common.Commands;
using Domain.Entities;

namespace Application.Users.Commands;

public class UserActivateCommand(int id) : CommandBase<User>
{
    public int Id { get; set; } = id;
}
