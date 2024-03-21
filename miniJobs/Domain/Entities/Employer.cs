namespace Domain.Entities;
[Table("employers")]
public class Employer
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
}