namespace ConsumerService;

public class EmailSender(EmailService emailService)
{
    private readonly EmailService _emailService = emailService;

    public async Task SendJobExpiringReminderEmailAsync(string creatorFullName, string creatorEmail, string jobName)
    {
        var body = $"""
            Poštovani {creatorFullName},<br /><br />
            Obavještavamo vas da rok za prijavu na posao "{jobName}" ističe za dva dana.<br />
            Ako želite omogućiti više prijava, možete produžiti rok za prijavu kako biste privukli dodatne kandidate.<br /><br />
            Srdačan pozdrav,<br />Mini Jobs tim
            """;

        await _emailService.SendEmailAsync(creatorEmail, "Obavještenje o isteku roka za prijavu", body);
    }

    public async Task SendJobRecommendationEmailAsync(string fullName, string email, string jobName)
    {
      
        var body = $"""
            Poštovani {fullName},<br /><br />
            Obavještavamo vas da je otvoren novi posao "{jobName}" koji odgovara vašim preferencijama.<br />
            Pozivamo vas da se prijavite na ovaj posao što prije kako ne biste propustili priliku.<br /><br />
            Srdačan pozdrav,<br />Mini Jobs tim
            """;

        await _emailService.SendEmailAsync(email, "Obavještenje o novom otvorenom poslu", body);
    }
}