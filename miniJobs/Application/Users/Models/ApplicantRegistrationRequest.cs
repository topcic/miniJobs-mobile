using Domain.Enums;

namespace Application.Users.Models;
public class ApplicantRegistrationRequest
{
    public string Email { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string UserName { get; set; }
    public string Password { get; set; }
    public string PhoneNumber { get; set; }
    public int Gender { get; set; }
    public int CityId { get; set; }
}