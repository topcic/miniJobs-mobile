using Application.Applicants.Models;
using Application.Common.Extensions;
using Application.Jobs.Queries;
using AutoMapper;
using Domain.Dtos;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

public class JobGetApplicantsQueryHandler : IRequestHandler<JobGetApplicantsQuery, IEnumerable<ApplicantDTO>>
{
    private readonly IJobRepository jobRepository;
    private readonly IMapper mapper;



    public JobGetApplicantsQueryHandler(IJobRepository jobRepository, IMapper mapper)
    {
        this.jobRepository = jobRepository;
        this.mapper = mapper;
    }


    public async Task<IEnumerable<ApplicantDTO>> Handle(JobGetApplicantsQuery request, CancellationToken cancellationToken)
    {
        var job = await jobRepository.TryFindAsync(request.JobId);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);
        return await jobRepository.GetApplicants(request.JobId);
    }
}
