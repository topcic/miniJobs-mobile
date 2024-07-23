using Application.Common.Commands;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobApplyCommand(int id, bool apply) : CommandBase<Job>
{
    public int Id { get; set; } = id;
    public bool Apply { get; set; } = apply;
}