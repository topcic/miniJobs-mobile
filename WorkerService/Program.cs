using Application.Common.Interfaces;
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
            await Host.CreateDefaultBuilder(args)
                .ConfigureServices((hostContext, services) =>
                {
                    services.AddMassTransit(configure =>
                    {
                        configure.SetKebabCaseEndpointNameFormatter();
                        configure.AddConsumer<Consumers.ApplicationExpiryEmailConsumer>();
                        configure.AddConsumer<Consumers.JobRecommendationEmailConsumer>();
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

                    services.AddSingleton<IEmailSender, EmailSender>();
                })
                .Build()
                .RunAsync();
        }
    }
}