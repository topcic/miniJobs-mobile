using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class JobRecommendationJobTypeEntityTypeConfiguration : IEntityTypeConfiguration<JobRecommendationJobType>
{
    public void Configure(EntityTypeBuilder<JobRecommendationJobType> builder)
    {
        builder.HasKey(x => new { x.JobRecommendationId, x.JobTypeId });
        builder.HasOne<JobRecommendation>().WithMany().HasForeignKey(x => x.JobRecommendationId);
        builder.HasOne<JobType>().WithMany().HasForeignKey(x => x.JobTypeId);
    }
}