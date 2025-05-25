using Application.Common.Interfaces;
using Infrastructure.Mails;
using MassTransit;

namespace ConsumerService.Consumers;

public class ApplicationExpiryEmailConsumer(IEmailSender emailSender) : IConsumer<ApplicationExpiryMail>
{
    private readonly IEmailSender emailSender = emailSender;

    public async Task Consume(ConsumeContext<ApplicationExpiryMail> context)
    {
        var message = context.Message;
        await emailSender.SendJobExpiringReminderEmailAsync(message.CreatorName, message.CreatorEmail, message.JobName);
    }
}