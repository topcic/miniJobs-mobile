using Application.Common.Interfaces;
using Infrastructure.Common.Interfaces;
using Infrastructure.Mails;
using MassTransit;
using Microsoft.Extensions.DependencyInjection;

namespace Infrastructure.BackgroundServices;

public class ApplicationExpiryReminder : IBackgroundService
{
    private readonly IServiceScopeFactory scopeFactory;

    public ApplicationExpiryReminder(IServiceScopeFactory scopeFactory)
    {
        this.scopeFactory = scopeFactory;
    }

    public async Task ExecuteAsync()
    {
        Console.WriteLine($"ApplicationExpiryReminder started at: {DateTime.Now}");
        using var scope = scopeFactory.CreateScope();
        var jobRepository = scope.ServiceProvider.GetRequiredService<IJobRepository>();
        var userManagerRepository = scope.ServiceProvider.GetRequiredService<IUserManagerRepository>();
        var emailSender = scope.ServiceProvider.GetRequiredService<IEmailSender>();
        var publishEndpoint = scope.ServiceProvider.GetRequiredService<IPublishEndpoint>();
        var jobs = await jobRepository.GetJobsExpiringInTwoDaysAsync();

        foreach (var job in jobs)
        {
            var creator = await userManagerRepository.TryFindAsync(job.CreatedBy.Value);
            var message = new Infrastructure.Mails.ApplicationExpiryMail
            {
                JobName = job.Name,
                CreatorEmail = creator.Email,
                CreatorName = creator.FirstName

            };
            Console.WriteLine($"Publishing message: JobName={message.JobName}, CreatorEmail={message.CreatorEmail}");
            await publishEndpoint.Publish(message);
        }
    }
}
