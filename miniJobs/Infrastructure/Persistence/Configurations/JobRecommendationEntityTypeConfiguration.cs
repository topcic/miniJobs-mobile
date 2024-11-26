using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class JobRecommendationEntityTypeConfiguration : IEntityTypeConfiguration<JobRecommendation>
{
    public void Configure(EntityTypeBuilder<JobRecommendation> builder)
    {
        builder.HasKey(x => x.Id);
        builder.HasOne<User>().WithMany().HasForeignKey(x => x.CreatedBy);
        builder.HasOne<User>().WithMany().HasForeignKey(x => x.LastModifiedBy);
        builder.HasIndex(x => x.CreatedBy)
            .IsUnique()
            .HasDatabaseName("IX_JobRecommendation_Unique_User");
    }
}