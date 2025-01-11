using Application.Employers.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Employers.Handlers;

public class EmployerGetActiveJobsQueryHandler(IEmployerRepository employerRepository) : IRequestHandler<EmployerGetActiveJobsQuery, IEnumerable<Job>>
{
    public async Task<IEnumerable<Job>> Handle(EmployerGetActiveJobsQuery request, CancellationToken cancellationToken)
    {
        var employer = await employerRepository.TryFindAsync(request.EmployerId);
        return await employerRepository.GetActiveJobs(employer.Id, request.UserId.Value);
    }
}