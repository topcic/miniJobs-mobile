namespace Infrastructure.Options;

public class AuthCodeOptions
{
    public int ForgotPasswordCodeExpirationMinutes { get; set; }
    public int TwoFactorAuthCodeExpirationMinutes { get; set; }
}
