using Application.Users.Commands;
using FluentValidation;

namespace Application.Users.Validators;
public class UserForgotPasswordCommandValidator : AbstractValidator<UserForgotPasswordCommand>
{
    public UserForgotPasswordCommandValidator()
    {
        RuleFor(x => x.Email)
    .Cascade(CascadeMode.Stop)
    .NotEmpty().OverridePropertyName("Email").WithMessage("EMAIL_IS_REQUIRED")
    .EmailAddress().WithMessage("NOT_VALID_EMAIL_ADDRESS");
    }
}
