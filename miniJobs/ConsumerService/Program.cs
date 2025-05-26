using ConsumerService.Consumers;
using MassTransit;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using ConsumerService;
using ConsumerService.Options; // Za EmailService i EmailSender

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
                cfg.Host(new Uri(context.Configuration["RABBITMQ:Host"]!), h =>
                {
                    h.Username(context.Configuration["RABBITMQ:Username"]!);
                    h.Password(context.Configuration["RABBITMQ:Password"]!);
                });
                cfg.ReceiveEndpoint("application-expiry-email-queue", e => e.ConfigureConsumer<ApplicationExpiryEmailConsumer>(ctx));
                cfg.ReceiveEndpoint("job-recommendation-email-queue", e => e.ConfigureConsumer<JobRecommendationEmailConsumer>(ctx));
            });
        });

        // Registriraj EmailService i EmailSender
        services.Configure<EmailSenderOptions>(context.Configuration.GetSection("EmailSenderOptions"));
        services.AddSingleton<EmailService>();
        services.AddSingleton<EmailSender>();
    })
    .Build();

host.Run();