using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class JobRecommendationCityEntityTypeConfiguration : IEntityTypeConfiguration<JobRecommendationCity>
{
    public void Configure(EntityTypeBuilder<JobRecommendationCity> builder)
    {
        builder.HasKey(x => new { x.JobRecommendationId, x.CityId });
        builder.HasOne<JobRecommendation>().WithMany().HasForeignKey(x => x.JobRecommendationId);
        builder.HasOne(x => x.City)
                .WithMany()
                .HasForeignKey(x => x.CityId)
                .OnDelete(DeleteBehavior.Restrict);
    }
}