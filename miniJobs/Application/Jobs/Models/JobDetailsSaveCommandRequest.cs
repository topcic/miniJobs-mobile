using Domain.Enums;

namespace Application.Jobs.Models;

public class JobDetailsSaveCommandRequest
{
    public int Id { get; set; }
    public JobStatus Status { get; set; }
    public IEnumerable<int> JobTypes { get; set; }
    public JobScheduleInfo JobSchedule { get; set; }
    public string Description { get; set; }
}
