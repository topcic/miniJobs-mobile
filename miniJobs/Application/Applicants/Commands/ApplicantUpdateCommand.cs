using Application.Applicants.Models;
using Application.Common.Commands;
using Domain.Entities;

namespace Application.Applicants.Commands;

public class ApplicantUpdateCommand: CommandBase<Applicant>
{
    public int ApplicantId { get; set; }
    public ApplicantUpdateRequest Request { get; set; }
    public ApplicantUpdateCommand(int applicantId, ApplicantUpdateRequest request)
    {
        ApplicantId = applicantId;
        Request = request;
    }
}
