using Application.Common.Extensions;
using Application.Users.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Users.Validators;

public class UserActivateCommandValidator : AbstractValidator<UserActivateCommand>
{
    private readonly IUserManagerRepository userRepository;
    public UserActivateCommandValidator(IUserManagerRepository userRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await Validate(x));
        this.userRepository = userRepository;
    }
    private new async Task<bool> Validate(UserActivateCommand command)
    {
        var user = await userRepository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("USER_NOT_EXISTS", () => user == null);

        ExceptionExtension.Validate("CAN_NOT_ACTIVATE_ANOTHER_USER", () => command.Id!=command.UserId && command.RoleId!= "Administrator");

        return true;
    }
}