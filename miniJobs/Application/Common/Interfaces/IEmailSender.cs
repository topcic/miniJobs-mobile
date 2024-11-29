namespace Application.Common.Interfaces;

public interface IEmailSender
{
    Task SendActivationEmailAsync(string fullName, string email, string verificationCode);
    Task SendUserRatingNotificationEmailAsync(string creatorFullName, string ratedUserMail, string jobName);
    Task SendJobExpiringReminderEmailAsync(string creatorFullName, string creatorEmail, string jobName);
    Task SendJobRecommendationEmailAsync(string fullName, string email, string jobName);
}
