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

    public async Task SendUserRatingNotificationEmailAsync(string creatorFullName, string ratedUserMail, string jobName)
    {
        var body = string.Format("Poštovani,<br /><br />Obavještavamo vas da je korisnik {0} ocijenio vaš rad na poslu {1}.<br />Mini Jobs", creatorFullName, jobName);

        await emailService.SendEmailAsync(ratedUserMail, "Obavještenje o ocjeni rada", body);
    }
}
