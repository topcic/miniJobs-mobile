using Application.Common.Commands;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobSaveCommand(int id, bool save) : CommandBase<Job>
{
    public int Id { get; set; } = id;
    public bool Save { get; set; } = save;
}
