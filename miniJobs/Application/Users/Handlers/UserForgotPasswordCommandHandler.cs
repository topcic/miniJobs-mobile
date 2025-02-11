using Application.Common.Interfaces;
using Application.Common.Methods;
using Application.Users.Commands;
using Data.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;
using Microsoft.Extensions.Configuration;
using System.Transactions;

namespace Application.Users.Handlers;

public class UserForgotPasswordCommandHandler(IUserManagerRepository userManager,IUserAuthCodeRepository userAuthCodeRepository, IEmailSender emailSender, IConfiguration configuration) : IRequestHandler<UserForgotPasswordCommand, bool>
{
    public async Task<bool> Handle(UserForgotPasswordCommand request, CancellationToken cancellationToken)
    {
        using (var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
        {
            var user = await userManager.TryFindByEmailAsync(request.Email.ToLower());


            if (user == null)
                return true; //prevents the assumption that there is a user with that email


            if (!user.AccountConfirmed)
            {
                return false;
            }

            var code = GenerateCode.Generate();
            var userAuthCode = new UserAuthCode()
            {
                Type= (int)UserAuthCodeType.SetPassword,
                GeneratedAt = DateTime.UtcNow,
                Code = code,
                UserId = user.Id,
                Used = false
            };
            await userAuthCodeRepository.InsertAsync(userAuthCode);
            var fullName = $"{user.FirstName} {user.LastName}";
            await emailSender.SendSetPasswordAsync(fullName, user.Email, code);

            ts.Complete();
            return true;
        }
    }
}