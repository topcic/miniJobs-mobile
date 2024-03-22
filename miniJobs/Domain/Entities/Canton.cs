using Domain.Interfaces;

namespace Domain.Entities;
[Table("cantons")]
public class Canton : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    public string Name { get; set; }

    [NotMapped]
    public List<City> CantonCities { get; set; }
}
