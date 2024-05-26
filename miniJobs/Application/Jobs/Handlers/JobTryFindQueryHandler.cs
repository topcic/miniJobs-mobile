using Application.Jobs.Queries;
using Domain.Entities;
using Domain.Interfaces;
using MediatR;

namespace Application.Jobs.Handlers;

public class JobTryFindQueryHandler: IRequestHandler<JobTryFindQuery, Job>
{
    private readonly IJobRepository jobRepository;


    public JobTryFindQueryHandler(IJobRepository jobRepository)
    {
        this.jobRepository = jobRepository;
    }


    public async Task<Job> Handle(JobTryFindQuery request, CancellationToken cancellationToken)
    {

        var job = await jobRepository.TryFindAsync(request.JobId);
        var jobDetails = await jobRepository.GetWithDetailsAsync(job.Id);
        job.Schedules = jobDetails.Schedules;
        job.AdditionalPaymentOptions = jobDetails.AdditionalPaymentOptions;
        job.PaymentQuestion = jobDetails.PaymentQuestion;

        return job;
    }
}