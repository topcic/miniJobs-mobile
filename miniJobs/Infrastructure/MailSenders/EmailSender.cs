using Application.Common.Interfaces;
using Infrastructure.Common.Interfaces;

namespace Infrastructure.MailSenders;


public class EmailSender(IEmailService emailService) : IEmailSender
{
    private readonly IEmailService emailService = emailService;

    public async Task SendActivationEmailAsync(string fullName, string email, string verificationCode)
    {
        var body = string.Format("Poštovani {0},<br /><br />Hvala Vam što ste registrovali na našu aplikaciju! Da biste završili registraciju, molim vas unesite kod: {1}.<br />Mini Jobs", fullName, verificationCode);

        await emailService.SendEmailAsync(email, "Potvrda registracije na Mini Jobs", body);
    }
}