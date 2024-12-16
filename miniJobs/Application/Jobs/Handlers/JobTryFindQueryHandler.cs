using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Enums;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

sealed class JobTryFindQueryHandler(IJobRepository jobRepository) : IRequestHandler<JobTryFindQuery, Job>
{
    public async Task<Job> Handle(JobTryFindQuery request, CancellationToken cancellationToken)
    {
        var isApplicant=request.RoleId==Roles.Applicant.ToString();
        var job = await jobRepository.GetWithDetailsAsync(request.JobId, isApplicant,request.UserId.Value);
        return job;
    }
}