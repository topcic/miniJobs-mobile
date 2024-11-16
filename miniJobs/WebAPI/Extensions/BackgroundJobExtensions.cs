using Hangfire;
using Infrastructure.BackgroundServices;
using Infrastructure.Hangfire;

namespace WebAPI.Extensions;

public static class BackgroundJobExtensions
{
    public static IServiceCollection AddJobManagerAndServices(this IServiceCollection services)
    {
        services.AddSingleton<JobManager>();
        var jobConfiguration = new JobConfiguration(services);

        jobConfiguration.AddRecurringJob<CompleteJobApplications>();
        jobConfiguration.AddRecurringJob<ApplicationExpiryReminder>();

        return services;
    }

    public static IApplicationBuilder StartRecurringJobs(this IApplicationBuilder app)
    {
        using var scope = app.ApplicationServices.CreateScope();
        var manager = scope.ServiceProvider.GetRequiredService<JobManager>();
        manager.Start();
        return app;
    }
}
