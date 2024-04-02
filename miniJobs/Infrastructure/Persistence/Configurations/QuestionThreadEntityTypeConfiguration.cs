using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class QuestionThreadEntityTypeConfiguration : IEntityTypeConfiguration<QuestionThread>
{
    public void Configure(EntityTypeBuilder<QuestionThread> builder)
    {
        builder.HasOne<Job>().WithMany().HasForeignKey(x => x.JobId);
    }
}