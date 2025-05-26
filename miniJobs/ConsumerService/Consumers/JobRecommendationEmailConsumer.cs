using Application.JobRecommendations.Models;
using MassTransit;

namespace ConsumerService.Consumers;

public class JobRecommendationEmailConsumer(EmailSender _emailSender) : IConsumer<JobRecommendationMail>
{

    public async Task Consume(ConsumeContext<JobRecommendationMail> context)
    {
        var message = context.Message;
        await _emailSender.SendJobRecommendationEmailAsync(message.FullName, message.Mail, message.JobName);
    }
}