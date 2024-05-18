namespace Application.Tokens.Models;
public class AuthTokenResponse
{
    public string AccessToken { get; set; }
    public double ExpiresIn { get; set; }
    public string RefreshToken { get; set; }
}