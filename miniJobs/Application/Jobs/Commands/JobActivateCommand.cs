using Application.Common.Commands;
using Domain.Entities;
using Domain.Enums;

namespace Application.Jobs.Commands;

public class JobActivateCommand(int id, int status) : CommandBase<Job>
{
    public int Id { get; set; } = id;
    public JobStatus Status { get; set; } = (JobStatus)status;
}