using Application.Common.Extensions;
using Application.Users.Commands;
using Data.Entities;
using Domain.Enums;
using Domain.Interfaces;
using FluentValidation;
using Microsoft.Extensions.Configuration;

namespace Application.Users.Validators;

public class UserChangePasswordCommandValidator : AbstractValidator<UserChangePasswordCommand>
{
    private readonly IUserAuthCodeRepository userAuthCodeRepository;
    private readonly IConfiguration configuration;
    public UserChangePasswordCommandValidator(IUserAuthCodeRepository userAuthCodeRepository, IConfiguration configuration)
    {
        RuleFor(x => x.ChangePasswordRequest.NewPassword)
    .Cascade(CascadeMode.Stop)
    .NotEmpty().OverridePropertyName("NewPassword").WithMessage("PASSWORD_IS_REQUIRED")
    .Length(8, 100).WithMessage("NOT_VALID_STRING_LENGHT");

        RuleFor(x => x.ChangePasswordRequest.AuthCode)
    .NotEmpty().OverridePropertyName("AuthCode").WithMessage("AUTH_CODE_IS_REQURED");
        RuleFor(x => x).MustAsync(async (x, cancellation) => await ValidateAuthCode(x));
        this.userAuthCodeRepository = userAuthCodeRepository;
        this.configuration = configuration;
    }
    private async Task<bool> ValidateAuthCode(UserChangePasswordCommand command)
    {

        UserAuthCode authCode = await userAuthCodeRepository.FindOneAsync(x => x.Code == command.ChangePasswordRequest.AuthCode);

        ExceptionExtension.Validate("AUTH_CODE_NOT_VALID", () => authCode == null);

        ExceptionExtension.Validate("AUTH_CODE_NOT_VALID", () => authCode.Used);
        ExceptionExtension.Validate("AUTH_CODE_NOT_VALID", () => authCode.Type != (int)UserAuthCodeType.SetPassword);
        string expirationMinutes = configuration["AuthCodeOptions:ForgotPasswordCodeExpirationMinutes"];
        int authCodeExpirationTimeInMinutes = int.Parse(expirationMinutes);
        ExceptionExtension.Validate("AUTH_CODE_NOT_VALID", () => authCode.GeneratedAt.AddMinutes(authCodeExpirationTimeInMinutes) < DateTime.UtcNow);

        return true;
    }
}