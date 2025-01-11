using Application.Applicants.Models;
using Application.Common.Commands;
using Domain.Entities;

namespace Application.Applicants.Commands;

public class ApplicantUpdateCommand(int applicantId, ApplicantUpdateRequest request) : CommandBase<Applicant>
{
    public int ApplicantId { get; set; } = applicantId;
    public ApplicantUpdateRequest Request { get; set; } = request;
}
