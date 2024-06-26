﻿using System.Transactions;
using Application.Common.Extensions;
using Application.Common.Interfaces;
using Application.Common.Methods;
using Application.Users.Commands;
using Application.Users.Models;
using AutoMapper;
using Data.Entities;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

public class RegistrationCommandHandler(IUserManagerRepository userManager,
    IApplicantRepository applicantRepository, IMapper mapper, IEmployerRepository employerRepository, IEmailSender emailSender,
    IUserAuthCodeRepository userAuthCodeRepository, ISecurityProvider securityProvider) : IRequestHandler<RegistrationCommand, UserRegistrationResponse>
{
    private readonly IUserManagerRepository userManager = userManager;
    private readonly IApplicantRepository applicantRepository = applicantRepository;
    private readonly IMapper mapper = mapper;
    private readonly IEmployerRepository employerRepository = employerRepository;
    private readonly IEmailSender emailSender = emailSender;
    private readonly IUserAuthCodeRepository userAuthCodeRepository = userAuthCodeRepository;
    private readonly ISecurityProvider securityProvider = securityProvider;
  

    public async Task<UserRegistrationResponse> Handle(RegistrationCommand command, CancellationToken cancellationToken)
    {
        UserRegistrationResponse response = new();

        using (var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
        {
            var registeredUser = await userManager.TryFindByEmailAsync(command.Request.Email.ToLower());
            ExceptionExtension.Validate("Email adresa se već koristi. Molimo izaberite drugu email adresu.", () => registeredUser != null);

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