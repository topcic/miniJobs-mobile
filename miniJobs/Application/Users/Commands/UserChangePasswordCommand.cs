using Application.Common.Commands;
using Application.Users.Models;

namespace Application.Users.Commands;
public class UserChangePasswordCommand(UserChangePasswordRequest changePasswordRequest) : CommandBase<bool>
{
    public UserChangePasswordRequest ChangePasswordRequest { get; set; } = changePasswordRequest;
}