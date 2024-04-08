using Application.Users.Models;
using AutoMapper;
using Domain.Entities;

namespace Application.Users.Mapping;

public class UserMapping : Profile
{
    public UserMapping()
    {
        CreateMap<RegistrationRequest, User>();
    }
}