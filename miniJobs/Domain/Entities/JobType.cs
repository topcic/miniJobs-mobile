namespace Domain.Entities;

[Table("job_types")]
public class JobType
{
    [Key]
    [Column("id")]
    public int Id { get; set; }
    [Column("name")]
    public string Name { get; set; }
}