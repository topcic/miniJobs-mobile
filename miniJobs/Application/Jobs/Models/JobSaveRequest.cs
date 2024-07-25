using Domain.Enums;

namespace Application.Jobs.Models;

public class JobSaveRequest
{
    public int Id { get; set; }
    public string Name { get; set; }
    public string StreetAddressAndNumber { get; set; }
    public int CityId { get; set; }
    public JobStatus Status { get; set; }
    public int? JobTypeId{ get; set; }
    public JobScheduleInfo? JobSchedule { get; set; }
    public Dictionary<int, List<int>?> AnswersToPaymentQuestions { get; set; }
    public int? RequiredEmployees { get; set; }
    public string? Description { get; set; }
    public int? Wage { get; set; }
    public int? ApplicationsDuration { get; set; }
}