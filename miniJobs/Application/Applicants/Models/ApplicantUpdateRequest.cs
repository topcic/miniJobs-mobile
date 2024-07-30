using Microsoft.AspNetCore.Http;

namespace Application.Applicants.Models;

public class ApplicantUpdateRequest
{
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string PhoneNumber { get; set; }
    public int CityId { get; set; }
    public string Description { get; set; }
    public string Experience { get; set; }
    public decimal WageProposal { get; set; }
    public IFormFile CvFile { get; set; }
    public List<int> JobTypes { get; set; }
}

