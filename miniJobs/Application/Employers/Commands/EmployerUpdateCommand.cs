using Application.Common.Commands;
using Application.Employers.Models;
using Domain.Entities;

namespace Application.Employers.Commands;

public class EmployerUpdateCommand(int employerId, EmployerUpdateRequest request) : CommandBase<Employer>
{
    public EmployerUpdateRequest Request { get; set; } = request;
    public int EmployerId { get; set; } = employerId;

}
