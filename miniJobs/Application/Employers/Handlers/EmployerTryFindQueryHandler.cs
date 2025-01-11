using Application.Employers.Queries;
using Domain.Dtos;
using Domain.Interfaces;
using MediatR;

namespace Application.Employers.Handlers;
public class EmployerTryFindQueryHandler(IEmployerRepository employerRepository) : IRequestHandler<EmployerTryFindQuery, EmployerDTO>
{
    public async Task<EmployerDTO> Handle(EmployerTryFindQuery request, CancellationToken cancellationToken)
    {

        var employer = await employerRepository.GetWithDetailsAsync(request.Id);
        return employer;
    }
}