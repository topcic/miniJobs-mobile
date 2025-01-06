using Application.Common.Commands;
using Application.Jobs.Models;
using Domain.Entities;

namespace Application.Jobs.Commands;

public class JobStep3UpdateCommand(JobStep3Request request) : CommandBase<Job>
{
    public JobStep3Request Request { get; set; } = request;
}