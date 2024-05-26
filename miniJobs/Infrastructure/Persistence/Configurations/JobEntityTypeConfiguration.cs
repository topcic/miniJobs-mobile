using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;


public class JobEntityTypeConfiguration : IEntityTypeConfiguration<Job>
{
    public void Configure(EntityTypeBuilder<Job> builder)
    {
        builder.HasKey(x => x.Id);
        builder.HasOne<JobType>().WithMany().HasForeignKey(x => x.JobTypeId).OnDelete(DeleteBehavior.NoAction);
    }
}
