using Domain.Entities;
using Domain.Enums;

namespace Domain.Dtos;

public class ApplicantDTO
{
    public int Id { get; set; }
    public byte[]? Cv { get; set; }
    public string? Experience { get; set; }
    public string? Description { get; set; }
    public decimal? WageProposal { get; set; }
    public DateTime Created { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Email { get; set; }
    public string? PhoneNumber { get; set; }
    public int? CityId { get; set; }
    public bool Deleted { get; set; }
    public bool AccountConfirmed { get; set; }
    public int? CreatedBy { get; set; }
    public byte[]? Photo { get; set; }
    public string Role { get; set; }
    public ICollection<ApplicantJobType> ApplicantJobTypes { get; set; }
    public City City { get; set; }
    public decimal AverageRating { get; set; }
    public int NumberOfFinishedJobs { get; set; }
    public int JobApplicationId { get; set; }
    public bool IsRated { get; set; }
    public JobApplicationStatus ApplicationStatus { get; set; }
    public IEnumerable<JobType> JobTypes { get; set; }

}
