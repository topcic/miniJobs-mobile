using Application.Employers.Models;
using AutoMapper;
using Domain.Entities;

namespace Application.Employers.Mapping;

public class EmployerMapping : Profile
{
    public EmployerMapping()
    {
        CreateMap<EmployerInsertRequest, User>();
        CreateMap<EmployerUpdateRequest, User>();
        CreateMap<EmployerUpdateRequest, Employer>();
    }
}
