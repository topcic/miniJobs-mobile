using Domain.Interfaces;

namespace Domain.Entities;
[Table("documents")]
public class Document : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("created", TypeName = "timestamp without time zone")]
    public DateTime Created { get; set; }

    [Column("created_by")]
    public int CreatedBy { get; set; }

    [Column("file_name")]
    public string FileName { get; set; }

    [Column("container_name")]
    public string ContainerName { get; set; }

    [Column("file_name_prefix")]
    public string FileNamePrefix { get; set; }
}