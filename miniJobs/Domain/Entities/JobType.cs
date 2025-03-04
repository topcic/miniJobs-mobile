using Domain.Interfaces;

namespace Domain.Entities;

[Table("job_types")]
public class JobType : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }
    [Column("name")]
    public string Name { get; set; }

    [Column("is_deleted")]
    public bool IsDeleted { get; set; }
}