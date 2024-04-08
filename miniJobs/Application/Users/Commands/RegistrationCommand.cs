using Application.Common.Commands;
using Application.Users.Models;

namespace Application.Users.Commands;

public class RegistrationCommand(RegistrationRequest request) : CommandBase<UserRegistrationResponse>
{
    public RegistrationRequest Request { get; set; } = request;
}