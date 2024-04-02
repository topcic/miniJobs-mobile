using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class JobQuestionEntityTypeConfiguration : IEntityTypeConfiguration<JobQuestion>
{
    public void Configure(EntityTypeBuilder<JobQuestion> builder)
    {
        builder.HasOne<Job>().WithOne().HasForeignKey<JobQuestion>(x => x.JobId);
        builder.HasOne<Question>().WithOne().HasForeignKey<JobQuestion>(x => x.QuestionId);
    }
}