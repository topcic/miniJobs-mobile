namespace Domain.Entities;
[Table("cantons")]
public class Canton
{
    [Key]
    [Column("id")]
    public Guid Id { get; set; }

    [Column("name")]
    public string Name { get; set; }

    [NotMapped]
    public List<City> CantonCities { get; set; }
}
