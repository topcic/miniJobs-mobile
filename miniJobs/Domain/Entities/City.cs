using Domain.Interfaces;

namespace Domain.Entities;

[Table("cities")]
public class City : IEntity<int>
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
    public int? CountryId { get; set; }

    [NotMapped]
    public Country Country { get; set; }

    [Column("is_deleted")]
    public bool IsDeleted { get; set; }
}