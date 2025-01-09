using Application.Common.Interfaces;
using Application.Users.Commands;
using Data.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

sealed class UserChangePasswordCommandHandler(IUserManagerRepository userManager, IUserAuthCodeRepository userAuthCodeRepository, ISecurityProvider securityProvider) : IRequestHandler<UserChangePasswordCommand, bool>
{
    public async Task<bool> Handle(UserChangePasswordCommand command, CancellationToken cancellationToken)
    {
        UserAuthCode authCode = await userAuthCodeRepository.FindOneAsync(x => x.Code == command.ChangePasswordRequest.AuthCode);
        authCode.Used = true;
        await userAuthCodeRepository.UpdateAsync(authCode);
        var user = await userManager.TryFindAsync(authCode.UserId);
        var generatedPassword = securityProvider.EncodePassword(command.ChangePasswordRequest.NewPassword);
        user.PasswordHash = generatedPassword;

        await userManager.UpdateAsync(user);
        return true;
    }
}
