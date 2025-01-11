using Application.Common.Queries;
using Domain.Dtos;

namespace Application.Employers.Queries;

public class EmployerTryFindQuery(int id) : QueryBase<EmployerDTO>
{
    public int Id { get; set; } = id;
}