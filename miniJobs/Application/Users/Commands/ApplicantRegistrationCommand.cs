using Application.Common.Commands;
using Application.Users.Models;

namespace Application.Users.Commands;

public class ApplicantRegistrationCommand(ApplicantRegistrationRequest request) : CommandBase<UserRegistrationResponse>
{
    public ApplicantRegistrationRequest Request { get; set; } = request;
}