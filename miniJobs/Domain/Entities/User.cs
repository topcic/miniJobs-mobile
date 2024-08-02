using Domain.Enums;
using Domain.Interfaces;

namespace Domain.Entities;


[Table("users")]
public class User : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("first_name")]
    public string FirstName { get; set; }

    [Column("last_name")]
    public string LastName { get; set; }

    [Column("email")]
    public string Email { get; set; }

    [Column("phone_number")]
    public string? PhoneNumber { get; set; }

    [Column("gender")]
    public Gender? Gender { get; set; }

    [Column("date_of_birth")]
    public DateTime? DateOfBirth { get; set; }

    [Column("city_id")]
    public int? CityId { get; set; }

    [Column("deleted")]
    public bool Deleted { get; set; }

    [Column("account_confirmed")]
    public bool AccountConfirmed { get; set; } = false;

    [Column("password_hash")]
    public string? PasswordHash { get; set; }

    [Column("access_failed_count")]
    public int AccessFailedCount { get; set; }

    [Column("created")]
    public DateTime Created { get; set; }

    [Column("created_by")]
    public int? CreatedBy { get; set; }

    [Column("photo")]
    public byte[]? Photo { get; set; }

    [NotMapped]
    public string Role { get; set; }

    public City City { get; set; }

    [NotMapped]
    public string FullName { get; set; }

    [NotMapped]
    public Employer Employer { get; set; }
}