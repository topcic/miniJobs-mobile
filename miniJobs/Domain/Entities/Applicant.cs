using Domain.Interfaces;

namespace Domain.Entities;
[Table("applicants")]
public class Applicant : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("cv_id")]
    public int? CvId { get; set; }

    [Column("experience")]
    public string? Experience { get; set; }

    [Column("photo_id")]
    public int? PhotoId { get; set; }

    [Column("description")]
    public string? Description { get; set; }

    [Column("wage_proposal")]
    public string? WageProposal { get; set; }

    [Column("confirmation_code")]
    public Guid? ConfirmationCode { get; set; }

    [Column("access_failed_count")]
    public int AccessFailedCount { get; set; }

    [Column("created", TypeName = "timestamp without time zone")]
    public DateTime Created { get; set; }

    [Column("created_by")]
    public int? CreatedBy { get; set; }
}