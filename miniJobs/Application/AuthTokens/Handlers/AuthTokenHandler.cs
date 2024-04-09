using System.Security.Authentication;
using Application.Common.Extensions;
using Application.Common.Interfaces;
using Application.Tokens.Models;
using Data.Entities;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Tokens.Commands;

/// <summary>
/// Represents auth token handler
/// </summary>
public class AuthTokenHandler(IUserManagerRepository userManager, ISecurityProvider securityProvider, IUserAuthCodeRepository userAuthCodeRepository, IJwtProvider jwtProvider) : IRequestHandler<AuthTokenCommand, AuthTokenResponse>
{
    private readonly IUserManagerRepository userManager = userManager;
    private readonly IJwtProvider jwtProvider = jwtProvider;
    private readonly ISecurityProvider securityProvider = securityProvider;
    private readonly IUserAuthCodeRepository userAuthCodeRepository = userAuthCodeRepository;
    private const int authCodeExpirationTimeInMinutes = 5;

    public async Task<AuthTokenResponse> Handle(AuthTokenCommand command, CancellationToken cancellationToken)
    {
        switch (command.Request.GrantType.ToLower())
        {
            case "password":
                {
                    var user = await userManager.TryFindByEmailAsync(command.Request.Email.ToLower());

                    ExceptionExtension.Validate("USERNAME_OR_PASSWORD_INVALID", () => user == null);
                    ExceptionExtension.Validate("USERNAME_OR_PASSWORD_INVALID", () => !user.AccountConfirmed);
                    ExceptionExtension.Validate("USERNAME_OR_PASSWORD_INVALID", () => user.Deleted);

                    var generatedPassword = securityProvider.EncodePassword(command.Request.Password);
                    var isUserAuthenticated = user.PasswordHash == generatedPassword;
                    ExceptionExtension.Validate("USERNAME_OR_PASSWORD_INVALID", () => !isUserAuthenticated);

                    var userRoles = await userManager.GetAllRolesAsync(user.Id);
                    ExceptionExtension.Validate("USERNAME_OR_PASSWORD_INVALID", () => !userRoles.Any());

                    var role = await userManager.TryFindRoleAsync(userRoles.FirstOrDefault().RoleId);
                    ExceptionExtension.Validate("USERNAME_OR_PASSWORD_INVALID", () => role == null);

                    return await jwtProvider.GenerateTokenAndRefreshToken(user, role);
                }
            case "refresh":
                {
                    ExceptionExtension.Validate("REFRESH_TOKEN_IS_MISSING", () => string.IsNullOrEmpty(command.Request.RefreshToken));
                    RefreshToken receivedToken = await jwtProvider.ValidateRefreshToken(command.Request.RefreshToken);

                    var user = await userManager.TryFindAsync(receivedToken.UserId.Value);
                    ExceptionExtension.Validate("ACCOUNT_NOT_APPROVED", () => user == null);

                    var userRoles = await userManager.GetAllRolesAsync(user.Id);
                    ExceptionExtension.Validate("ACCOUNT_NOT_VALID", () => !userRoles.Any());

                    var role = await userManager.TryFindRoleAsync(userRoles.FirstOrDefault().RoleId);
                    ExceptionExtension.Validate("ACCOUNT_NOT_VALID", () => role == null);

                    return await jwtProvider.GenerateTokenAndRefreshToken(user, role);
                }
            case "authcode":
                {
                    ExceptionExtension.Validate("AUTH_CODE_IS_MISSING", () => string.IsNullOrEmpty(command.Request.AuthCode));

                    UserAuthCode authCode = await userAuthCodeRepository.FindOneAsync(x => x.Code == command.Request.AuthCode);

                    ExceptionExtension.Validate("AUTH_CODE_NOT_VALID", () => authCode == null);

                    ExceptionExtension.Validate("AUTH_CODE_NOT_VALID", () => authCode.Used);

                    ExceptionExtension.Validate("AUTH_CODE_NOT_VALID", () => authCode.GeneratedAt.AddMinutes(authCodeExpirationTimeInMinutes) < DateTime.UtcNow);

                    authCode.Used = true;
                    await userAuthCodeRepository.UpdateAsync(authCode);

                    var user = await userManager.TryFindAsync(authCode.UserId);

                    ExceptionExtension.Validate("ACCOUNT_NOT_APPROVED", () => user == null);

                    var userRoles = await userManager.GetAllRolesAsync(authCode.UserId);
                    ExceptionExtension.Validate("ACCOUNT_NOT_VALID", () => !userRoles.Any());

                    var role = await userManager.TryFindRoleAsync(userRoles.FirstOrDefault().RoleId);
                    ExceptionExtension.Validate("ACCOUNT_NOT_VALID", () => role == null);

                    if (!user.AccountConfirmed)
                    {
                        user.AccountConfirmed = true;
                        await userManager.UpdateAsync(user);
                    }

                    return await jwtProvider.GenerateTokenAndRefreshToken(user, role);
                }
            default:
                throw new AuthenticationException("BAD_REQUEST");
        }
    }
}