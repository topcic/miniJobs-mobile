using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class JobTypeAssignmentEntityTypeConfiguration : IEntityTypeConfiguration<JobTypeAssignment>
{
    public void Configure(EntityTypeBuilder<JobTypeAssignment> builder)
    {
        builder.HasKey(x => new { x.JobId, x.JobTypeId });
        builder.HasOne<Job>().WithMany().HasForeignKey(x => x.JobId);
        builder.HasOne<JobType>().WithMany().HasForeignKey(x => x.JobTypeId);
    }
}