using Application.Common.Queries;
using Domain.Entities;

namespace Application.Employers.Queries;

public class EmployerTryFindQuery : QueryBase<Employer>
{
    public int Id { get; set; }

    public EmployerTryFindQuery(int id)
    {
        Id = id;
    }
}