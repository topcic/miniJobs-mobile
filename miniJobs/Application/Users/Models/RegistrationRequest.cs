namespace Application.Users.Models;
public class RegistrationRequest
{
    public string Email { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Password { get; set; }
    public string PhoneNumber { get; set; }
    public int Gender { get; set; }
    public int CityId { get; set; }
    public string RoleId { get; set; }
}