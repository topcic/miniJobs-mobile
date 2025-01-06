namespace Application.Jobs.Models;

public class JobStep1Request
{
    public int? Id { get; set; }
    public string Name { get; set; }
    public string StreetAddressAndNumber { get; set; }
    public string Description { get; set; }
    public int CityId { get; set; }
}
