using Application.Users.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

sealed class UserUpdateCommandHandler(IUserManagerRepository repository) : IRequestHandler<UserUpdateCommand, User>
{
    public async Task<User> Handle(UserUpdateCommand command, CancellationToken cancellationToken)
    {
        await repository.UpdateAsync(command.User);
        return command.User;
    }
}