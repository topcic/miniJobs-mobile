using Application.Common.Commands;
using Domain.Entities;
using Microsoft.AspNetCore.Http;

namespace Application.Users.Commands;

public class UserUpdatePhotoCommand(int userId,IFormFile photo) : CommandBase<User>
{
    public IFormFile Photo { get; set; } = photo;
    public int UserId { get; set; } = userId;
}