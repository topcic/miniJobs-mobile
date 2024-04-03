using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class ApplicantJobTypeEntityTypeConfiguration : IEntityTypeConfiguration<ApplicantJobType>
{
    public void Configure(EntityTypeBuilder<ApplicantJobType> builder)
    {
        builder.HasKey(x => new { x.ApplicantId, x.JobTypeId });
        builder.HasOne<Applicant>().WithMany().HasForeignKey(x => x.ApplicantId);
        builder.HasOne<JobType>().WithMany().HasForeignKey(x => x.JobTypeId);
    }
}
