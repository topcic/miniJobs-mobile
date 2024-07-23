using Application.Common.Extensions;
using Application.Employers.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Employers.Handlers;
public class EmployerTryFindQueryHandler : IRequestHandler<EmployerTryFindQuery, Employer>
{
    private readonly IEmployerRepository employerRepository;


    public EmployerTryFindQueryHandler(IEmployerRepository employerRepository)
    {
        this.employerRepository = employerRepository;
    }


    public async Task<Employer> Handle(EmployerTryFindQuery request, CancellationToken cancellationToken)
    {

        var employer = await employerRepository.GetWithDetailsAsync(request.Id);
        ExceptionExtension.Validate("EMPOLOYER_NOT_EXISTS", () => employer == null);
        return employer;
    }
}