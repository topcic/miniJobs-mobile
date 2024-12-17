using Domain.Common;
using Domain.Enums;
using Domain.Interfaces;

namespace Domain.Entities;

[Table("jobs")]
public class Job : BaseAuditableEntity, IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("name")]
    public string Name { get; set; }

    [Column("description")]
    public string Description { get; set; }

    [Column("street_address_and_number")]
    public string StreetAddressAndNumber { get; set; }

    [Column("applications_duration")]
    public int? ApplicationsDuration { get; set; }

    [Column("status")]
    public JobStatus Status { get; set; }
    [Column("required_employees")]
    public int? RequiredEmployees { get; set; }


    [Column("wage")]
    public int? Wage { get; set; }

    [Column("city_id")]
    public int CityId { get; set; }

    [Column("job_type_id")]
    public int? JobTypeId { get; set; }

    [Column("completed_with_applicants")]
    public bool CompletedWithApplicants { get; set; }

    public virtual JobType JobType { get; set; }
    public virtual City City { get; set; }
    public virtual ICollection<ProposedAnswer> Schedules { get; set; }
    public virtual ProposedAnswer PaymentQuestion { get; set; }
    public virtual ICollection<ProposedAnswer>? AdditionalPaymentOptions { get; set; }
    [NotMapped]
    public  int? NumberOfApplications { get; set; }

    [NotMapped]
    public string EmployerFullName { get; set; }

    [NotMapped]
    public bool IsApplied { get; set; }

    [NotMapped]
    public bool IsSaved { get; set; }


    #region
    private Dictionary<StatusTransition, JobStatus> transitions = new Dictionary<StatusTransition, JobStatus>
        {
            { new StatusTransition(JobStatus.Draft, JobCommand.Delete), JobStatus.Inactive },
            { new StatusTransition(JobStatus.Draft, JobCommand.Activate), JobStatus.Active },
            { new StatusTransition(JobStatus.Active, JobCommand.Delete), JobStatus.Inactive },
            { new StatusTransition(JobStatus.Active, JobCommand.ApplicationsCompleted), JobStatus.ApplicationsCompleted },
            { new StatusTransition(JobStatus.ApplicationsCompleted, JobCommand.Complete), JobStatus.Completed }
        };

    private JobStatus GetNext(JobCommand command)
    {
        StatusTransition transition = new StatusTransition(Status, command);
        JobStatus nextStatus;
        if (!transitions.TryGetValue(transition, out nextStatus))
        {
            throw new Exception($"Invalid incoming order status transition: {Status} -> {command}");
        }
        return nextStatus;
    }

    public JobStatus MoveNext(JobCommand command)
    {
        Status = GetNext(command);
        return Status;
    }

    private class StatusTransition
    {
        readonly JobStatus CurrentStatus;
        readonly JobCommand Command;

        public StatusTransition(JobStatus currentStatus, JobCommand command)
        {
            CurrentStatus = currentStatus;
            Command = command;
        }

        public override int GetHashCode()
        {
            return CurrentStatus.GetHashCode() + Command.GetHashCode();
        }

        public override bool Equals(object obj)
        {
            StatusTransition other = obj as StatusTransition;
            return other != null && CurrentStatus == other.CurrentStatus && Command == other.Command;
        }
    }

    #endregion


}