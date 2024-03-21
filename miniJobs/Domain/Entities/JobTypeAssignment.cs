namespace Domain.Entities;

[Table("job_type_assigments")]
public class JobTypeAssignment
{
    [Column("job_id")]
    public int JobId { get; set; }

    [Column("job_type_id")]
    public int JobTypeId { get; set; }
}