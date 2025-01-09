namespace Application.Users.Models;

public class UserChangePasswordRequest
{
    public string AuthCode { get; set; }

    public string NewPassword { get; set; }
}
