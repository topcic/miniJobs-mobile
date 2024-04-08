namespace Application.Common.Interfaces;

public interface IEmailSender
{
    Task SendActivationEmailAsync(string fullName, string email, string verificationCode);
}
