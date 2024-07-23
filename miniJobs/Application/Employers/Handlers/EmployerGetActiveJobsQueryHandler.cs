using Application.Common.Extensions;
using Application.Employers.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Employers.Handlers;

public class EmployerGetActiveJobsQueryHandler : IRequestHandler<EmployerGetActiveJobsQuery, IEnumerable<Job>>
{
    private readonly IEmployerRepository employerRepository;


    public EmployerGetActiveJobsQueryHandler(IEmployerRepository employerRepository)
    {
        this.employerRepository = employerRepository;
    }


    public async Task<IEnumerable<Job>> Handle(EmployerGetActiveJobsQuery request, CancellationToken cancellationToken)
    {
        var employer = await employerRepository.GetWithDetailsAsync(request.EmployerId);
        ExceptionExtension.Validate("EMPOLOYER_NOT_EXISTS", () => employer == null);
        return await employerRepository.GetActiveJobs(employer.Id, request.UserId.Value);
    }
}