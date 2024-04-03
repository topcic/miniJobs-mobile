using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class JobQuestionEntityTypeConfiguration : IEntityTypeConfiguration<JobQuestion>
{
    public void Configure(EntityTypeBuilder<JobQuestion> builder)
    {
        builder.HasOne<Job>().WithOne().HasForeignKey<JobQuestion>(x => x.JobId).OnDelete(DeleteBehavior.NoAction);
        builder.HasOne<Question>().WithOne().HasForeignKey<JobQuestion>(x => x.QuestionId).OnDelete(DeleteBehavior.NoAction);
    }
}