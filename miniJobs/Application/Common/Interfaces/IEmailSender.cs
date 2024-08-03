namespace Application.Common.Interfaces;

public interface IEmailSender
{
    Task SendActivationEmailAsync(string fullName, string email, string verificationCode);
    Task SendUserRatingNotificationEmailAsync(string creatorFullName, string ratedUserMail, string jobName);
}
