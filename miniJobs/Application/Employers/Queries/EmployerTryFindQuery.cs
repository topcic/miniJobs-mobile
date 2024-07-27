using Application.Common.Queries;
using Domain.Dtos;
using Domain.Entities;

namespace Application.Employers.Queries;

public class EmployerTryFindQuery : QueryBase<EmployerDTO>
{
    public int Id { get; set; }

    public EmployerTryFindQuery(int id)
    {
        Id = id;
    }
}