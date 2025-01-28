using Application.Common.Commands;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobDeleteByAdminCommand(int id):CommandBase<Job>
{
    public int Id { get; set; } = id;
}
