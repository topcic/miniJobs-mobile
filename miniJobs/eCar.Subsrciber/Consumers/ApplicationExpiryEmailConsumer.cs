namespace Subscriber.Consumers;

public class ApplicationExpiryEmailConsumer(EmailSender emailSender)
{
    public async Task ProcessMessage(string creatorName, string creatorEmail, string jobName)
    {
        await emailSender.SendJobExpiringReminderEmailAsync(creatorName, creatorEmail, jobName);
    }
}