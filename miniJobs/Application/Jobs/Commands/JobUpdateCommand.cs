using Application.Common.Commands;
using Application.Jobs.Models;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobUpdateCommand(JobSaveRequest request) : CommandBase<Job>
{
    public JobSaveRequest Request { get; set; } = request;
}