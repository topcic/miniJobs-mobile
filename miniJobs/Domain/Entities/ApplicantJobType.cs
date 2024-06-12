namespace Domain.Entities;

[Table("applicant_job_types")]
public class ApplicantJobType
{
    [Column("applicant_id")]
    public int ApplicantId { get; set; }
    public Applicant Applicant { get; set; }


    [Column("job_type_id")]
    public int JobTypeId { get; set; }
  
    public JobType JobType { get; set; }
}