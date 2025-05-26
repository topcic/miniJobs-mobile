using ConsumerService.Mails;
using MassTransit;

namespace ConsumerService.Consumers;

public class ApplicationExpiryEmailConsumer(EmailSender emailSender) : IConsumer<ApplicationExpiryMail>
{

    public async Task Consume(ConsumeContext<ApplicationExpiryMail> context)
    {
        var message = context.Message;
        await emailSender.SendJobExpiringReminderEmailAsync(message.CreatorName, message.CreatorEmail, message.JobName);
    }
}