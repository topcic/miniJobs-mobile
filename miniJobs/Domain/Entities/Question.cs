using Domain.Interfaces;

namespace Domain.Entities;

[Table("questions")]
public class Question : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    public string Name { get; set; }
}
