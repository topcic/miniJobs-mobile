using Application.Common.Extensions;
using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

public class JobTryFindQueryHandler: IRequestHandler<JobTryFindQuery, Job>
{
    private readonly IJobRepository jobRepository;


    public JobTryFindQueryHandler(IJobRepository jobRepository)
    {
        this.jobRepository = jobRepository;
    }


    public async Task<Job> Handle(JobTryFindQuery request, CancellationToken cancellationToken)
    {
        var isApplicant=request.RoleId==Roles.Applicant.ToString();
        var job = await jobRepository.GetWithDetailsAsync(request.JobId, isApplicant,request.UserId.Value);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);
        return job;
    }
}