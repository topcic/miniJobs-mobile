using Application.Common.Interfaces;
using Infrastructure.Mails;
using MassTransit;

namespace Infrastructure.MessageProcessors;

public class ApplicationExpiryEmailConsumer : IConsumer<ApplicationExpiryMail>
{
    private readonly IEmailSender emailSender;

    public ApplicationExpiryEmailConsumer(IEmailSender emailSender)
    {
        this.emailSender = emailSender;
        Console.WriteLine("ApplicationExpiryEmailConsumer initialized.");
    }

    public async Task Consume(ConsumeContext<ApplicationExpiryMail> context)
    {
        var message = context.Message;
        Console.WriteLine($"Job reminder message consumed for Job: {message.JobName}");
        message.CreatorEmail = "27topcic.mahir@gmail.com";
        await emailSender.SendJobExpiringReminderEmailAsync(message.CreatorName, message.CreatorEmail, message.JobName);
    }
}
