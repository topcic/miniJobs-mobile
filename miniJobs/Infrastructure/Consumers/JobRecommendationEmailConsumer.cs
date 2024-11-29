using Application.Common.Interfaces;
using Application.JobRecommendations.Models;
using MassTransit;

namespace Infrastructure.Consumers;

public class JobRecommendationEmailConsumer(IEmailSender emailSender) : IConsumer<JobRecommendationMail>
{
    public async Task Consume(ConsumeContext<JobRecommendationMail> context)
    {
        var message = context.Message;
        await emailSender.SendJobRecommendationEmailAsync(message.FullName, message.Mail, message.JobName);
    }
}