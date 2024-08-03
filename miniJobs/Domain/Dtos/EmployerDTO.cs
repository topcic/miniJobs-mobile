using Domain.Entities;
using Domain.Enums;

namespace Domain.Dtos;

public class EmployerDTO
{
    public int Id { get; set; }
    public string? Name { get; set; }
    public string? IdNumber { get; set; }
    public string? CompanyPhoneNumber { get; set; }
    public DateTime Created { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Email { get; set; }
    public string? PhoneNumber { get; set; }
    public Gender? Gender { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public int? CityId { get; set; }
    public bool Deleted { get; set; }
    public int? CreatedBy { get; set; }
    public byte[]? Photo { get; set; }
    public string Role { get; set; }
    public City City { get; set; }
    public decimal AverageRating { get; set; }
    public string StreetAddressAndNumber { get; set; }
    public bool IsRated { get; set; }

}
