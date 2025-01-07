using Application.Common.Commands;

namespace Application.Users.Commands;

public class UserForgotPasswordCommand(string email) : CommandBase<bool>
{
    public string Email { get; set; } = email;
}