
using System.Net;
using System.Net.Mail;

namespace SubscribeService;
public class EmailService()
{

    public async Task SendEmailAsync(string toEmail, string subject, string body)
    {
        try
        {
            string smtpServer = Environment.GetEnvironmentVariable("EMAILSENDER_PROVIDER_EMAIL") ?? "smtp.gmail.com";
            int smtpPort = int.Parse(Environment.GetEnvironmentVariable("EMAILSENDER_PORT") ?? "587");
            string fromMail = Environment.GetEnvironmentVariable("EMAILSENDER_MAIL_ADDRESS") ?? "minijobs2023@gmail.com";
            string password = Environment.GetEnvironmentVariable("EMAILSENDER_KEY") ?? "mqpeirblrthovtjd";
            MailMessage message = new()
            {
                From = new MailAddress(fromMail),
                Subject = subject,
                Body = body,
                IsBodyHtml = true
            };

            message.To.Add(new MailAddress(toEmail));

            SmtpClient client = new(smtpServer, smtpPort)
            {
                EnableSsl = true,
                UseDefaultCredentials = false,
                Credentials = new NetworkCredential(fromMail, password)
            };

            client.Send(message); // Or await Task.Run(() => client.Send(message)) if you want to simulate async
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Error sending email: {ex.Message}");

        }
    }
}

