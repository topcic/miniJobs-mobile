namespace Application.Tokens.Models;
public class AuthTokenRequest
{
    public string Email { get; set; }
    public string Password { get; set; }
    public string GrantType { get; set; }
    public string RefreshToken { get; set; }
    public string AuthCode { get; set; }
    public int PublicToken { get; set; }
}