using Application.Common.Extensions;
using Application.Users.Commands;
using Domain.Interfaces;
using FluentValidation;

namespace Application.Users.Validators;

public class UserDeleteCommandValidator : AbstractValidator<UserDeleteCommand>
{
    private readonly IUserManagerRepository userRepository;
    public UserDeleteCommandValidator(IUserManagerRepository userRepository)
    {
        RuleFor(x => x).MustAsync(async (x, cancellation) => await Validate(x));
        this.userRepository = userRepository;
    }
    private new async Task<bool> Validate(UserDeleteCommand command)
    {
        var user = await userRepository.TryFindAsync(command.DeleteUserId);
        ExceptionExtension.Validate("USER_NOT_EXISTS", () => user == null);
        return true;
    }
}