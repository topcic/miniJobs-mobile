using Application.Users.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

sealed class UserActivateCommandHandler(IUserManagerRepository userManager) : IRequestHandler<UserActivateCommand, User>
{
    public async Task<User> Handle(UserActivateCommand request, CancellationToken cancellationToken)
    {
        var user = await userManager.TryFindAsync(request.Id);
        user.Deleted = false;
        await userManager.UpdateAsync(user);
        return user;
    }
}