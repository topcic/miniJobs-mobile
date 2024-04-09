using Application.Common.Commands;
using Application.Employers.Models;
using Domain.Entities;

namespace Application.Employers.Commands;

public class EmployerInsertCommand(EmployerInsertRequest request) : CommandBase<Employer>
{
    public EmployerInsertRequest Request { get; set; } = request;
}