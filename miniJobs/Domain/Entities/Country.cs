using Domain.Interfaces;

namespace Domain.Entities;

[Table("countries")]
public class Country : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    public string Name { get; set; }

    [Column("is_deleted")]
    public bool IsDeleted { get; set; }
}