using Infrastructure.Common.Interfaces;
using Microsoft.Extensions.Logging;
using System.Net.Mail;
using System.Net;
using Infrastructure.Options;
using Microsoft.Extensions.Options;

namespace Infrastructure.Services;

public class EmailService(IOptions<EmailSenderOptions> options,ILogger<EmailService> logger) : IEmailService
{
    private readonly EmailSenderOptions options= options.Value;

    private readonly ILogger _logger=logger;

    public async Task SendEmailAsync(string toEmail, string subject,string body)
    {
        try
        {
            MailMessage message = new()
            {
                From = new MailAddress(options.MailAddress)
            };
            message.To.Add(new MailAddress(toEmail));
            message.Subject = subject;

            message.Body = string.Format(body);

            // Set the message body as HTML
            message.IsBodyHtml = true;

            // Set the SMTP client details
            SmtpClient client = new(options.ProviderEmail, options.Port.Value)
            {
                EnableSsl = true,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(options.MailAddress, options.Key)
            };

            // Send the message
            client.Send(message);
            _logger.LogInformation($"Email to {toEmail} queued successfully.");
        }
        catch (Exception)
        {
            _logger.LogWarning($"Failure Email to {toEmail}!");
        }
    }
}
