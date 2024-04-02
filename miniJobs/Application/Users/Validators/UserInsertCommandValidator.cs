using Application.Users.Commands;
using FluentValidation;

namespace Application.Users.Validators;

public class UserInsertCommandValidator : AbstractValidator<UserInsertCommand>
{
    public UserInsertCommandValidator()
    {
        RuleFor(x => x.Request.Email)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("Email").WithMessage("Email je obavezno polje")
            .EmailAddress().WithMessage("Nevalidna email adresa");

        RuleFor(x => x.Request.FirstName)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("FirstName").WithMessage("Ime je obavezno polje")
            .Length(2, 20).WithMessage("Nevalidna dužina");

        RuleFor(x => x.Request.LastName)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("LastName").WithMessage("Prezime je obavezno polje")
            .Length(2, 30).WithMessage("Nevalidna dužina");

    }
}
