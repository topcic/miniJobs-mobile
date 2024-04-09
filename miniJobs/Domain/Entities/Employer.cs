using Domain.Interfaces;

namespace Domain.Entities;
[Table("employers")]
public class Employer : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    public string? Name { get; set; }

    [Column("id_number")]
    public string? IdNumber { get; set; }

    [Column("company_phone_number")]
    public string? CompanyPhoneNumber { get; set; }

    [NotMapped]
    public User User { get; set; }
}