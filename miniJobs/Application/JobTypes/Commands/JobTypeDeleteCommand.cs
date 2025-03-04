using Application.Common.Commands;
using Domain.Entities;

namespace Application.JobTypes.Commands;

public class JobTypeDeleteCommand(int id) : CommandBase<JobType>
{
    public int Id { get; set; } = id;
}