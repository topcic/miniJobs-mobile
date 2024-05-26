using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class JobQuestionEntityTypeConfiguration : IEntityTypeConfiguration<JobQuestion>
{
    public void Configure(EntityTypeBuilder<JobQuestion> builder)
    {
        builder.HasKey(x => x.Id);
        builder.HasOne<Job>().WithMany().HasForeignKey(x => x.JobId).OnDelete(DeleteBehavior.NoAction);
        builder.HasOne<Question>().WithMany().HasForeignKey(x => x.QuestionId).OnDelete(DeleteBehavior.NoAction);
    }
}