using Application.Common.Commands;
using Application.Jobs.Models;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobInsertCommand(JobStep1Request request) : CommandBase<Job>
{
    public JobStep1Request Request { get; set; } = request;
}