﻿using Application.Users.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Users.Validators;
public class ApplicantRegistrationCommandValidator : AbstractValidator<RegistrationCommand>
{
    public ApplicantRegistrationCommandValidator(ICityRepository cityRepository)
    {
        RuleFor(x => x.Request.Email)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("Email").WithMessage("Email je obavezno polje")
            .EmailAddress().WithMessage("Nevalidna dužina");

        RuleFor(x => x.Request.FirstName)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("FirstName").WithMessage("Ime je obavezno polje")
            .Length(2, 20).WithMessage("Nevalidna dužina");

        RuleFor(x => x.Request.LastName)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("LastName").WithMessage("Prezime je obavezno polje")
            .Length(2, 30).WithMessage("Nevalidna dužina");

        RuleFor(x => x.Request.Password)
            .Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("Password").WithMessage("Lozinka je obavezno polje")
            .Length(8, 100).WithMessage("Nevalidna dužina");

        RuleFor(x => x.Request.PhoneNumber).Cascade(CascadeMode.Stop)
            .NotEmpty().OverridePropertyName("PhoneNumber").WithMessage("Broj telefona je obavezno polje")
            .Length(9, 15).WithMessage("Nevalidna dužina");

        RuleFor(x => x.Request.CityId)
            .NotNull().OverridePropertyName("CityId").WithMessage("Grad je obavezno polje");

        RuleFor(x => x.Request.Gender)
          .NotNull().OverridePropertyName("Gender").WithMessage("Spol je obavezno polje");

           RuleFor(x => x.Request.CityId).MustAsync(async (id, cancellation) => await cityRepository.TryFindAsync(id) != null).OverridePropertyName("CityId").WithMessage("Grad ne postoji.");
    }
}