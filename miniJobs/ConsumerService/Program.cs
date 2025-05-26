using ConsumerService.Consumers;
using MassTransit;
using Microsoft.Extensions.Hosting;

var host = Host.CreateDefaultBuilder(args)
    .ConfigureServices((context, services) =>
    {
        services.AddMassTransit(configure =>
        {
            configure.AddConsumer<ApplicationExpiryEmailConsumer>();
            configure.AddConsumer<JobRecommendationEmailConsumer>();
            configure.SetKebabCaseEndpointNameFormatter();
            configure.UsingRabbitMq((ctx, cfg) =>
            {
                cfg.Host(new Uri(context.Configuration["RabbitMQ:Host"]!), h =>
                {
                    h.Username(context.Configuration["RabbitMQ:Username"]!);
                    h.Password(context.Configuration["RabbitMQ:Password"]!);
                });
                cfg.ReceiveEndpoint("application-expiry-email-queue", e => e.ConfigureConsumer<ApplicationExpiryEmailConsumer>(ctx));
                cfg.ReceiveEndpoint("job-recommendation-email-queue", e => e.ConfigureConsumer<JobRecommendationEmailConsumer>(ctx));
            });
        });
    })
    .Build();

host.Run();