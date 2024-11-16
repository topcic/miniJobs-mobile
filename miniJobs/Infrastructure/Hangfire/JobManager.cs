using Infrastructure.Common.Interfaces;
using Infrastructure.Options;
using Microsoft.Extensions.Options;

namespace Hangfire;

public class JobManager
{
    private readonly IRecurringJobManager manager;
    private readonly IEnumerable<IBackgroundService> jobs;
    private readonly BackgroundJobServicesOptions options;

    public JobManager(IRecurringJobManager manager, IEnumerable<IBackgroundService> jobs, IOptions<BackgroundJobServicesOptions> options)
    {
        this.manager = manager;
        this.jobs = jobs;
        this.options = options.Value;
    }

    public void Start()
    {
        foreach (var job in jobs)
        {
            var service = options.Services.Find(x => x.Name == job.ToString()?.Split('.').Last());

            if (service != null && service.Enabled)
            {
                manager.AddOrUpdate(service.Name, () => job.ExecuteAsync(), service.Cron);
            }
        }
    }
}
