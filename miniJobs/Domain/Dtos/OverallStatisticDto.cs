namespace Domain.Dtos;

public class OverallStatisticDto
{
    public int TotalApplicants { get; set; }
    public int TotalEmployers { get; set; }
    public int TotalJobs { get; set; }
    public int TotalActiveJobs { get; set; }
    public double AverageEmployerRating { get; set; }
    public double AverageApplicantRating { get; set; }
}
