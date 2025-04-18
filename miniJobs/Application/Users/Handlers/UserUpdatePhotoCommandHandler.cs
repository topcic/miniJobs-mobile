﻿using Application.Users.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Users.Handlers;

public class UserUpdatePhotoCommandHandler(IUserManagerRepository userManager) : IRequestHandler<UserUpdatePhotoCommand, User>
{
    public async Task<User> Handle(UserUpdatePhotoCommand command, CancellationToken cancellationToken)
    {
        var user = await userManager.TryFindAsync(command.UserId);

        var ms = new MemoryStream();
        await command.Photo.OpenReadStream().CopyToAsync(ms, cancellationToken);
        user.Photo = ms.ToArray();

        await userManager.UpdateAsync(user);
        return user;
    }
}