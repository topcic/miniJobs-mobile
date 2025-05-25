using Application.Common.Interfaces;
using Application.JobRecommendations.Models;
using MassTransit;

namespace WorkerService.Consumers;

public class JobRecommendationEmailConsumer(IEmailSender emailSender) : IConsumer<JobRecommendationMail>
{
    private readonly IEmailSender _emailSender = emailSender;

    public async Task Consume(ConsumeContext<JobRecommendationMail> context)
    {
        var message = context.Message;
        await _emailSender.SendJobRecommendationEmailAsync(message.FullName, message.Mail, message.JobName);
    }
}