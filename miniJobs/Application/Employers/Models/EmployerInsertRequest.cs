namespace Application.Employers.Models;

public class EmployerInsertRequest
{
    public string Email { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Password { get; set; }
    public string PhoneNumber { get; set; }
    public int CityId { get; set; }
    public string IdNumber { get; set; }
    public string StreetAddressAndNumber { get; set; }
    public string CompanyPhoneNumber { get; set; }
    public string Name { get; set; }
}
