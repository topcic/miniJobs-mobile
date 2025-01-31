using Domain.Common;
using Domain.Interfaces;

namespace Domain.Entities;

[Table("ratings")]
public class Rating : BaseAuditableEntity, IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("value")]
    public int Value { get; set; }

    [Column("comment")]
    public string Comment { get; set; }

    [Column("job_application_id")]
    public int JobApplicationId { get; set; }

    [Column("rated_user_id")]
    public int RatedUserId { get; set; }

    [Column("is_active")]
    public bool IsActive { get; set; }

    [NotMapped]
    public string CreatedByFullName { get; set; }

    [NotMapped]
    public string RatedUserFullName { get; set; }

    [NotMapped]
    public string CreatedByRole{ get; set; }

    [NotMapped]
    public string RatedUserRole { get; set; }

    [NotMapped]
    public byte[]? Photo { get; set; }

}
