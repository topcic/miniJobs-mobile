using Application.Jobs.Models;
using AutoMapper;
using Domain.Entities;

namespace Application.Jobs.Mapping;
public class JobMapping : Profile
{
    public JobMapping()
    {
        CreateMap<JobInsertRequest, Job>();
        CreateMap<JobSaveRequest, Job>()
          .ForMember(model => model.Created, option => option.Ignore())
          .ForMember(model => model.CreatedBy, option => option.Ignore());
    }
}
