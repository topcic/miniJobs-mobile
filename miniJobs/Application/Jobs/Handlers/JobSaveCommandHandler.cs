using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

public class JobSaveCommandHandler : IRequestHandler<JobSaveCommand, Job>
{
    private readonly IJobRepository jobRepository;
    private readonly ISavedJobRepository savedJobRepository;



    public JobSaveCommandHandler(IJobRepository jobRepository, ISavedJobRepository savedJobRepository)
    {
        this.jobRepository = jobRepository;
        this.savedJobRepository = savedJobRepository;
    }

    public async Task<Job> Handle(JobSaveCommand command, CancellationToken cancellationToken)

    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await jobRepository.GetWithDetailsAsync(command.Id, true, command.UserId.Value);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);

        if (command.Save)
        {
            var savedJob = new SavedJob
            {
                JobId = job.Id,
                Created = DateTime.UtcNow,
                CreatedBy = command.UserId.Value
            };

            await savedJobRepository.InsertAsync(savedJob);
            job.IsSaved = true;

        }
        else
        {
            var savedJob= await savedJobRepository.FindOneAsync(x=>x.CreatedBy == command.UserId.Value && x.JobId== job.Id);
            ExceptionExtension.Validate("SAVED_JOB_NOT_EXISTS", () => savedJob == null);
            await savedJobRepository.DeleteAsync(savedJob);
            job.IsSaved = false;
        }

        ts.Complete();

        return job;
    }
}