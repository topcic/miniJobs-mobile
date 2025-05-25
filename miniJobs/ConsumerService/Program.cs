using Application.Common.Interfaces;
using ConsumerService.Consumers;
using Infrastructure.MailSenders;
using MassTransit;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace WorkerService
{
    public class Program
    {
        public static async Task Main(string[] args)
        {
            var builder = Host.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((hostingContext, config) =>
                {
                    config.AddJsonFile("appsettings.json", optional: true, reloadOnChange: true)
                          .AddJsonFile($"appsettings.{hostingContext.HostingEnvironment.EnvironmentName}.json", optional: true, reloadOnChange: true)
                          .AddEnvironmentVariables();
                    if (args != null)
                    {
                        config.AddCommandLine(args);
                    }
                })
                .ConfigureServices((hostContext, services) =>
                {
                    // Registracija aplikacionih i infrastrukture servisa
                    services.AddApplicationServices();
                    services.AddInfrastructureServices(hostContext.Configuration);

                    // Konfiguracija MassTransit-a sa RabbitMQ-om
                    services.AddMassTransit(configure =>
                    {
                        configure.SetKebabCaseEndpointNameFormatter();
                        configure.AddConsumer<ApplicationExpiryEmailConsumer>();
                        configure.AddConsumer<JobRecommendationEmailConsumer>();
                        configure.UsingRabbitMq((context, cfg) =>
                        {
                            cfg.Host(new Uri(hostContext.Configuration["RabbitMQ:Host"]!), h =>
                            {
                                h.Username(hostContext.Configuration["RabbitMQ:Username"]!);
                                h.Password(hostContext.Configuration["RabbitMQ:Password"]!);
                            });
                            cfg.ConfigureEndpoints(context);
                            Console.WriteLine("MassTransit RabbitMQ endpoints configured in Worker.");
                        });
                    });

                    // Registracija email sender-a
                    services.AddSingleton<IEmailSender, EmailSender>();
                });

            await builder.Build().RunAsync();
        }
    }
}