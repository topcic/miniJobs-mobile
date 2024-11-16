

using Infrastructure.Common.Interfaces;
using Microsoft.Extensions.DependencyInjection;

namespace Infrastructure.Hangfire;

public class JobConfiguration
{
    private readonly IServiceCollection services;

    public JobConfiguration(IServiceCollection services)
    {
        this.services = services;
    }

    public JobConfiguration AddRecurringJob<TJob>() where TJob : IBackgroundService
    {
        services.AddSingleton(typeof(IBackgroundService), typeof(TJob));
        return this;
    }
}