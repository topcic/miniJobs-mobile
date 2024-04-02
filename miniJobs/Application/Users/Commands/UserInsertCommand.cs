using Application.Common.Commands;
using Application.Users.Models;
using Domain.Entities;

namespace Application.Users.Commands;

public class UserInsertCommand(UserSaveRequest userInsertRequest) : CommandBase<User>
{
    public UserSaveRequest Request { get; set; } = userInsertRequest;
}