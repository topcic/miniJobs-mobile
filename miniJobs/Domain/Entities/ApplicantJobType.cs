namespace Domain.Entities;

[Table("applicant_job_types")]
public class ApplicantJobType
{
    [Column("applicant_id")]
    public int ApplicantId { get; set; }

    [Column("job_type_id")]
    public int JobTypeId { get; set; }
    [NotMapped]
    public JobType JobType { get; set; }
}