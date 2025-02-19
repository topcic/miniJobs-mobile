namespace Domain.Dtos;

public record JobCardDTO
{
    public int Id { get; set; }

    public string Name { get; set; }

    public string CityName { get; set; }

    public int? Wage { get; set; }

    public DateTime Created { get; set; }
}