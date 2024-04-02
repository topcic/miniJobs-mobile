using Domain.Common;
using Domain.Enums;
using Domain.Interfaces;

namespace Domain.Entities;

[Table("jobs")]
public class Job : BaseAuditableEntity, IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    public string Name { get; set; }

    [Column("description")]
    public string Description { get; set; }

    [Column("street_address_and_number")]
    public string StreetAddressAndNumber { get; set; }

    [Column("applications_end_to", TypeName = "timestamp without time zone")]
    public DateTime ApplicationsEndTo { get; set; }

    [Column("status")]
    public JobStatus Status { get; set; }
    [Column("required_employees")]
    public int RequiredEmployees { get; set; }

    [Column("wage")]
    public int? Wage { get; set; }

    [Column("employer_id")]
    public int EmployerId { get; set; }

    [Column("city_id")]
    public int CityId { get; set; }
}