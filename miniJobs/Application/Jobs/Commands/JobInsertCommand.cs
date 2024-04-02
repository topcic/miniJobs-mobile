using Application.Common.Commands;
using Application.Jobs.Models;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobInsertCommand(JobInsertRequest request) : CommandBase<Job>
{
    public JobInsertRequest Request { get; set; } = request;
}