using Application.Common.Interfaces;
using Application.Common.Methods;
using Application.Employers.Commands;
using AutoMapper;
using Data.Entities;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Employers.Handlers;

public class EmployerInsertCommandHandler(IUserManagerRepository userManager, IMapper mapper, IEmployerRepository employerRepository, IEmailSender emailSender,
    IUserAuthCodeRepository userAuthCodeRepository, ISecurityProvider securityProvider) : IRequestHandler<EmployerInsertCommand, Employer>
{
    public async Task<Employer> Handle(EmployerInsertCommand command, CancellationToken cancellationToken)
    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);

        var user = mapper.Map<User>(command.Request);
        var generatedPassword = securityProvider.EncodePassword(command.Request.Password);
        user.PasswordHash = generatedPassword;

        await userManager.InsertAsync(user);

        var employer = new Employer()
        {
            Id = user.Id,
            CompanyPhoneNumber = command.Request.CompanyPhoneNumber,
            Name = command.Request.Name,
            IdNumber = command.Request.IdNumber,

        };
        await employerRepository.InsertAsync(employer);

        var role = await userManager.TryFindRoleAsync("Employer");
        await userManager.AssignUserRoleAsync(user, role);

        var code = GenerateCode.Generate();
        var userAuthCode = new UserAuthCode()
        {
            GeneratedAt = DateTime.UtcNow,
            Code = code,
            UserId = user.Id,
            Used = false
        };
        await userAuthCodeRepository.InsertAsync(userAuthCode);

        await emailSender.SendActivationEmailAsync(employer.Name, user.Email, code);

        employer.User = user;

        ts.Complete();
        return employer;
    }
}
