using Application.Common.Extensions;
using Application.Users.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Users.Validators;

public class UserUpdatePhotoCommandValidator : AbstractValidator<UserUpdatePhotoCommand>
{
    private readonly IUserManagerRepository userManager;
    public UserUpdatePhotoCommandValidator(IUserManagerRepository userManager)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await Validate(x));
        this.userManager = userManager;
    }
    private async Task<bool> Validate(UserUpdatePhotoCommand command)
    {
        var user = await userManager.TryFindAsync(command.UserId);
        ExceptionExtension.Validate("USER_NOT_EXISTS", () => user == null);
        ExceptionExtension.Validate("PHOTO_IS_REQUIRED", () => command.Photo == null);
        return true;
    }
}