namespace Domain.Entities;

[Table("countries")]
public class Country
{
    [Key]
    [Column("id")]
    public Guid Id { get; set; }

    [Column("name")]
    public string Name { get; set; }
}