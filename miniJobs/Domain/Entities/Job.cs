using Domain.Common;
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

    [Column("applications_duration")]
    public int? ApplicationsDuration { get; set; }

    [Column("status")]
    public int Status { get; set; }
    [Column("required_employees")]
    public int? RequiredEmployees { get; set; }


    [Column("wage")]
    public int? Wage { get; set; }

    [Column("city_id")]
    public int CityId { get; set; }

    [Column("state")]
    public int State { get; set; }

    [Column("job_type_id")]
    public int? JobTypeId { get; set; }

    [NotMapped]
    public List<ProposedAnswer> Schedules { get; set; }

    [NotMapped]
    public ProposedAnswer PaymentQuestion { get; set; }

    [NotMapped]
    public List<ProposedAnswer> AdditionalPaymentOptions { get; set; }

    [NotMapped]
    public int NumberOfApplications { get; set; }

    [NotMapped]
    public JobType JobType { get; set; }

    [NotMapped]
    public City City { get; set; }

}