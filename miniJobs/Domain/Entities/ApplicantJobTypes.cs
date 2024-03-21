namespace Domain.Entities;

[Table("applicant_job_types")]
public class ApplicantJobTypes
{
    [Column("applicant_id")]
    public int ApplicantId { get; set; }

    [Column("job_type_id")]
    public int JobTypeId { get; set; }
}