namespace Application.Jobs.Models;

public class JobScheduleInfo
{
    public int QuestionId { get; set; }
    public IEnumerable<int> Answers { get; set; }
}
