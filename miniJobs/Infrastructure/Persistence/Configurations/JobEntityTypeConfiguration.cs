using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;


public class JobEntityTypeConfiguration : IEntityTypeConfiguration<Job>
{
    public void Configure(EntityTypeBuilder<Job> builder)
    {
        builder.HasKey(x => x.Id);
        builder.HasOne<JobType>().WithMany().HasForeignKey(x => x.JobTypeId).OnDelete(DeleteBehavior.NoAction);
        builder.HasOne<City>()
            .WithMany()
            .HasForeignKey(x => x.CityId)
            .OnDelete(DeleteBehavior.NoAction);
        builder.Ignore(x => x.JobType);
        builder.Ignore(x => x.City);
        builder.Ignore(x => x.Schedules);
        builder.Ignore(x => x.PaymentQuestion);
        builder.Ignore(x => x.AdditionalPaymentOptions);
    }
}
