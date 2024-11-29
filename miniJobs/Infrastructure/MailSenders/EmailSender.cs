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

    public async Task SendJobExpiringReminderEmailAsync(string creatorFullName, string creatorEmail, string jobName)
    {
        var body = string.Format(
            "Poštovani {0},<br /><br />" +
            "Obavještavamo vas da rok za prijavu na posao \"{1}\" ističe za dva dana.<br />" +
            "Ako želite omogućiti više prijava, možete produžiti rok za prijavu kako biste privukli dodatne kandidate.<br /><br />" +
            "Srdačan pozdrav,<br />Mini Jobs tim",
            creatorFullName,
            jobName
        );

        await emailService.SendEmailAsync(creatorEmail, "Obavještenje o isteku roka za prijavu", body);
    }

    public async Task SendJobRecommendationEmailAsync(string fullName, string email, string jobName)
    {
        var body = string.Format(
             "Poštovani {0},<br /><br />" +
             "Obavještavamo vas da je otvoren novi posao \"{1}\" koji odgovara vašim preferencijama.<br />" +
             "Pozivamo vas da se prijavite na ovaj posao što prije kako ne biste propustili priliku.<br /><br />" +
             "Srdačan pozdrav,<br />Mini Jobs tim",
             fullName,
             jobName
         );

        await emailService.SendEmailAsync(email, "Obavještenje o novom otvorenom poslu", body);
    }
}
