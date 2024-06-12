using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class ApplicantJobTypeEntityTypeConfiguration : IEntityTypeConfiguration<ApplicantJobType>
{
    public void Configure(EntityTypeBuilder<ApplicantJobType> builder)
    {
        builder.HasKey(ajt => new { ajt.ApplicantId, ajt.JobTypeId });
        builder.HasOne(ajt => ajt.Applicant)
               .WithMany(a => a.ApplicantJobTypes)
               .HasForeignKey(ajt => ajt.ApplicantId);
        builder.HasOne(ajt => ajt.JobType)
               .WithMany()
               .HasForeignKey(ajt => ajt.JobTypeId);
    }
}
