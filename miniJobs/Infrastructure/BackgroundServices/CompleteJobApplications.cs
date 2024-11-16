using Infrastructure.Common.Interfaces;
using Microsoft.Extensions.DependencyInjection;
using System.Transactions;

namespace Infrastructure.BackgroundServices;

public class CompleteJobApplications : IBackgroundService
{
    private readonly IServiceScopeFactory scopeFactory;

    public CompleteJobApplications(IServiceScopeFactory scopeFactory)
    {
        this.scopeFactory = scopeFactory;
    }

    public async Task ExecuteAsync()
    {
        Console.WriteLine($"CompleteJobApplications started at: {DateTime.Now}");

        using var scope = scopeFactory.CreateScope();
        using var ts = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled);
        var jobRepository = scope.ServiceProvider.GetRequiredService<IJobRepository>();
        var jobs = await jobRepository.GetExpiredActiveJobsAsync();

        foreach (var job in jobs)
        {

            job.Status = Domain.Enums.JobStatus.ApplicationsCompleted;
            await jobRepository.UpdateAsync(job);
        }
        ts.Complete();
    }
}