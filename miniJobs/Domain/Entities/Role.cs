using Domain.Interfaces;

namespace Domain.Entities;
[Table("roles")]
public class Role : IEntity<string>
{
    [Key]
    [Column("id")]
    public string Id { get; set; }

    [Column("description")]
    public string? Description { get; set; }
}
