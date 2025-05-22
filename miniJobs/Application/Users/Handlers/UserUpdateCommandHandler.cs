using Application.Users.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

sealed class UserUpdateCommandHandler(IUserManagerRepository repository) : IRequestHandler<UserUpdateCommand, User>
{
    public async Task<User> Handle(UserUpdateCommand command, CancellationToken cancellationToken)
    {
        var user = await repository.TryFindAsync(command.User.Id);
        user.FirstName = command.User.FirstName;
        user.LastName = command.User.LastName;
        user.PhoneNumber = command.User.PhoneNumber;
        await repository.UpdateAsync(user);
        return user;
    }
}