using System.Transactions;
using Application.Common.Interfaces;
using Application.Common.Methods;
using Application.Users.Commands;
using Application.Users.Models;
using AutoMapper;
using Data.Entities;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

public class RegistrationCommandHandler(IUserManagerRepository userManager,
    IApplicantRepository applicantRepository, IMapper mapper, IEmployerRepository employerRepository, IEmailSender emailSender,
    IUserAuthCodeRepository userAuthCodeRepository, ISecurityProvider securityProvider) : IRequestHandler<RegistrationCommand, UserRegistrationResponse>
{

    public async Task<UserRegistrationResponse> Handle(RegistrationCommand command, CancellationToken cancellationToken)
    {
        UserRegistrationResponse response = new();

        using (var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
        {
            var user = mapper.Map<User>(command.Request);
            var generatedPassword = securityProvider.EncodePassword(command.Request.Password);
            user.PasswordHash = generatedPassword;
            
            await userManager.InsertAsync(user);
            if (command.Request.RoleId == "Applicant")
            {
                var applicant = new Applicant()
                {
                    Id = user.Id
                };
                await applicantRepository.InsertAsync(applicant);
            }
            else
            {
                var employer = new Employer()
                {
                    Id = user.Id
                };
                await employerRepository.InsertAsync(employer);
            }
            var role = await userManager.TryFindRoleAsync(command.Request.RoleId);
            await userManager.AssignUserRoleAsync(user, role);
            var fullName = $"{user.FirstName} {user.LastName}";
            var code = GenerateCode.Generate();
            var userAuthCode = new UserAuthCode()
            {
                Type = UserAuthCodeType.TwoFactorAuthCode,
                GeneratedAt = DateTime.UtcNow,
                Code = code,
                UserId = user.Id,
                Used = false
            };
            await userAuthCodeRepository.InsertAsync(userAuthCode);

            await emailSender.SendActivationEmailAsync(fullName, user.Email,code);

            ts.Complete();
        }
        response.IsRegistered = true;
        return response;
    }
}