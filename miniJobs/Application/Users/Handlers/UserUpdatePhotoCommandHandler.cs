using Application.Common.Extensions;
using Application.Users.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

public class UserUpdatePhotoCommandHandler : IRequestHandler<UserUpdatePhotoCommand, User>
{
    private readonly IUserManagerRepository userManager;
    public UserUpdatePhotoCommandHandler(IUserManagerRepository userManager)
    {
        this.userManager = userManager;
    }
    public async Task<User> Handle(UserUpdatePhotoCommand command, CancellationToken cancellationToken)
    {
        var user = await userManager.TryFindAsync(command.UserId);
        ExceptionExtension.Validate("user_NOT_EXISTS", () => user == null);
        var ms = new MemoryStream();
        await command.Photo.OpenReadStream().CopyToAsync(ms, cancellationToken);
        user.Photo = ms.ToArray();

        await userManager.UpdateAsync(user);
        return user;
    }
}