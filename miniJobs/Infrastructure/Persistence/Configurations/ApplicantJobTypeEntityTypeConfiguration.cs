using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class ApplicantJobTypeEntityTypeConfiguration : IEntityTypeConfiguration<ApplicantJobType>
{
    public void Configure(EntityTypeBuilder<ApplicantJobType> builder)
    {
        builder.HasOne<Applicant>().WithMany().HasForeignKey(x => x.ApplicantId);
        builder.HasOne<JobType>().WithMany().HasForeignKey(x => x.JobTypeId);
    }
}
