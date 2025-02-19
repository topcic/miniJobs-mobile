using Application.Employers.Queries;
using Domain.Dtos;
using Domain.Interfaces;
using MediatR;

namespace Application.Employers.Handlers;

public class EmployerGetActiveJobsQueryHandler(IEmployerRepository employerRepository) : IRequestHandler<EmployerGetActiveJobsQuery, IEnumerable<JobCardDTO>>
{
    public async Task<IEnumerable<JobCardDTO>> Handle(EmployerGetActiveJobsQuery request, CancellationToken cancellationToken)
    {
        var employer = await employerRepository.TryFindAsync(request.EmployerId);
        return await employerRepository.GetActiveJobs(employer.Id, request.UserId.Value);
    }
}