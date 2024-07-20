using Application.Applicants.Models;
using AutoMapper;
using Domain.Entities;

namespace Application.Applicants.Mapping;
public class ApplicantMapping : Profile
{
    public ApplicantMapping()
    {
        CreateMap<Applicant, ApplicantResponse>()
            .ForMember(dest => dest.FirstName, opt => opt.MapFrom(src => src.User.FirstName))
            .ForMember(dest => dest.LastName, opt => opt.MapFrom(src => src.User.LastName))
            .ForMember(dest => dest.Email, opt => opt.MapFrom(src => src.User.Email))
            .ForMember(dest => dest.PhoneNumber, opt => opt.MapFrom(src => src.User.PhoneNumber))
            .ForMember(dest => dest.Gender, opt => opt.MapFrom(src => src.User.Gender))
            .ForMember(dest => dest.DateOfBirth, opt => opt.MapFrom(src => src.User.DateOfBirth))
            .ForMember(dest => dest.CityId, opt => opt.MapFrom(src => src.User.CityId))
            .ForMember(dest => dest.Deleted, opt => opt.MapFrom(src => src.User.Deleted))
            .ForMember(dest => dest.CreatedBy, opt => opt.MapFrom(src => src.User.CreatedBy))
            .ForMember(dest => dest.Photo, opt => opt.MapFrom(src => src.User.Photo))
            .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.User.Role))
            .ForMember(dest => dest.Cv, opt => opt.MapFrom(src => src.Cv))
            .ForMember(dest => dest.Experience, opt => opt.MapFrom(src => src.Experience))
            .ForMember(dest => dest.Description, opt => opt.MapFrom(src => src.Description))
            .ForMember(dest => dest.WageProposal, opt => opt.MapFrom(src => src.WageProposal))
            .ForMember(dest => dest.ApplicantJobTypes, opt => opt.MapFrom(src => src.ApplicantJobTypes))
            .ForMember(dest => dest.City, opt => opt.MapFrom(src => src.User.City))
            .ForMember(dest => dest.Role, opt => opt.MapFrom(src => src.User.Role)); 

    }

}