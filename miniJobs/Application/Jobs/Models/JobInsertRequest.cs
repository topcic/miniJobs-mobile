namespace Application.Jobs.Models;

public class JobInsertRequest
{
    public string Name { get; set; }
    public string Description { get; set; }
    public string StreetAddressAndNumber { get; set; }
    public int CityId { get; set; }
}
