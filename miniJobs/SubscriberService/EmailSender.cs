using Newtonsoft.Json;
using SubscriberService;

namespace SubscribeService;

public class EmailSender(EmailService emailService)
{
    private readonly EmailService _emailService = emailService;
    public async Task SendJobRecommendationEmailAsync(string message)
    {
        var emailData = JsonConvert.DeserializeObject<JobRecommendationMail>(message);

        var body = $"""
            Poštovani {emailData.FullName},<br /><br />
            Obavještavamo vas da je otvoren novi posao "{emailData.JobName}" koji odgovara vašim preferencijama.<br />
            Pozivamo vas da se prijavite na ovaj posao što prije kako ne biste propustili priliku.<br /><br />
            Srdačan pozdrav,<br />Mini Jobs tim
            """;

        await _emailService.SendEmailAsync(emailData.Mail, "Obavještenje o novom otvorenom poslu", body);

    }
}