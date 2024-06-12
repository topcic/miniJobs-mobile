using Domain.Interfaces;

namespace Domain.Entities;
[Table("applicants")]
public class Applicant : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("cv")]
    public byte[]? Cv { get; set; }

    [Column("experience")]
    public string? Experience { get; set; }

    [Column("description")]
    public string? Description { get; set; }

    [Column("wage_proposal")]
    public decimal? WageProposal { get; set; }

    [Column("confirmation_code")]
    public int? ConfirmationCode { get; set; }

    [Column("access_failed_count")]
    public int AccessFailedCount { get; set; }

    [Column("created")]
    public DateTime Created { get; set; }
    [NotMapped]
    public  User User { get; set; }
    [NotMapped]
    public ICollection<ApplicantJobType> ApplicantJobTypes { get; set; }
}