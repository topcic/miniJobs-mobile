using Application.Common.Commands;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobActivateCommand(int id, int status) : CommandBase<Job>
{
    public int Id { get; set; } = id;
    public int Status { get; set; } = status;
}