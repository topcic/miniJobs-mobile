using ConsumerService.Options;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Net;
using System.Net.Mail;

namespace ConsumerService;
public class EmailService(IOptions<EmailSenderOptions> options, ILogger<EmailService> logger)
{
    private readonly EmailSenderOptions _options = options.Value;

    public async Task SendEmailAsync(string toEmail, string subject, string body)
    {
        try
        {
            MailMessage message = new()
            {
                From = new MailAddress(_options.MailAddress),
                Subject = subject,
                Body = body,
                IsBodyHtml = true
            };

            message.To.Add(new MailAddress(toEmail));

            SmtpClient client = new(_options.ProviderEmail, _options.Port.Value)
            {
                EnableSsl = true,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(_options.MailAddress, _options.Key)
            };

            client.Send(message); // Or await Task.Run(() => client.Send(message)) if you want to simulate async
            logger.LogInformation("Email to {ToEmail} queued successfully.", toEmail);
        }
        catch (Exception ex)
        {
            logger.LogWarning(ex, "Failed to send email to {ToEmail}.", toEmail);
        }
    }
}

