namespace Domain.Entities;

[Table("cities")]
public class City
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    public string Name { get; set; }

    [Column("postcode")]
    public string Postcode { get; set; }

    [Column("municipality_code")]
    public string MunicipalityCode { get; set; }

    [Column("country_id")]
    public Guid? CountryId { get; set; }

    [NotMapped]
    public Country Country { get; set; }

    [Column("canton_id")]
    public Guid? CantonId { get; set; }
}