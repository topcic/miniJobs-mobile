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

    public virtual JobType JobType { get; set; }
    public virtual City City { get; set; }
    public virtual ICollection<ProposedAnswer> Schedules { get; set; }
    public virtual ProposedAnswer PaymentQuestion { get; set; }
    public virtual ICollection<ProposedAnswer>? AdditionalPaymentOptions { get; set; }
    public int? NumberOfApplications { get; set; }

}