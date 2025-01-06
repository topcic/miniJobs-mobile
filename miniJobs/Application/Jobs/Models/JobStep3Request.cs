namespace Application.Jobs.Models;

public class JobStep3Request
{
    public int Id { get; set; }
    public Dictionary<int, List<int>?> AnswersToPaymentQuestions { get; set; }
    public int? Wage { get; set; }
}
