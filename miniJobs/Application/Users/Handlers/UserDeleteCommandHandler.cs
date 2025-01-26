using Application.Users.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

sealed class UserDeleteCommandHandler(IUserManagerRepository userManager) : IRequestHandler<UserDeleteCommand, User>
{
    public async Task<User> Handle(UserDeleteCommand request, CancellationToken cancellationToken)
    {
        var user = await userManager.TryFindAsync(request.DeleteUserId);
        user.Deleted = true;
        await userManager.UpdateAsync(user);
        return user;
    }
}