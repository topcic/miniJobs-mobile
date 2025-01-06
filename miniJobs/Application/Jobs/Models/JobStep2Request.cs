namespace Application.Jobs.Models;

public class JobStep2Request
{
    public int Id { get; set; }
    public int JobTypeId { get; set; }
    public JobScheduleInfo? JobSchedule { get; set; }
    public int RequiredEmployees { get; set; }
    public int ApplicationsDuration { get; set; }
}