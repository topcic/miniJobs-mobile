﻿using Application.Common.Extensions;
using Application.Jobs.Commands;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;
using System.Transactions;

namespace Application.Jobs.Handlers;

public class JobActivateCommandHandler : IRequestHandler<JobActivateCommand, Job>
{
    private readonly IJobRepository _jobRepository;
    private readonly IJobTypeRepository _jobTypeRepository;



    public JobActivateCommandHandler(IJobRepository jobRepository, IJobTypeRepository jobTypeRepository)
    {
        _jobRepository = jobRepository;
        _jobTypeRepository = jobTypeRepository;
    }

    public async Task<Job> Handle(JobActivateCommand command, CancellationToken cancellationToken)

    {
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        Job job = await _jobRepository.TryFindAsync(command.Id);
        ExceptionExtension.Validate("JOB_NOT_EXISTS", () => job == null);
        JobType jobType = await _jobTypeRepository.TryFindAsync(job.JobTypeId.Value);
        //ExceptionExtension.Validate("JOB_TYPE_NOT_EXISTS", () => jobType == null);

        job.Status = (int)command.Status;

        await _jobRepository.UpdateAsync(job);

        var jobDetails = await _jobRepository.GetWithDetailsAsync(job.Id);
        job.Schedules = jobDetails.Schedules;
        job.AdditionalPaymentOptions = jobDetails.AdditionalPaymentOptions;
        job.PaymentQuestion = jobDetails.PaymentQuestion;
        job.JobType = jobType;
        job.City = jobDetails.City;

        ts.Complete();

        return job;
    }
}