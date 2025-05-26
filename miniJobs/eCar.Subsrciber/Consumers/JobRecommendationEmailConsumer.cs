using Subscriber;

namespace ConsumerService.Consumers;

public class JobRecommendationEmailConsumer(EmailSender _emailSender) 
{

    public async Task ProcessMessage(string fullName, string email, string jobName)
    {
        await _emailSender.SendJobRecommendationEmailAsync(fullName, email, jobName);
    }
}