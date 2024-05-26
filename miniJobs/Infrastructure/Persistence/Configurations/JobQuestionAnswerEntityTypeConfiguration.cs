using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;


public class JobQuestionAnswerEntityTypeConfiguration : IEntityTypeConfiguration<JobQuestionAnswer>
{
    public void Configure(EntityTypeBuilder<JobQuestionAnswer> builder)
    {
        builder.HasOne<ProposedAnswer>().WithMany().HasForeignKey(x => x.ProposedAnswerId).OnDelete(DeleteBehavior.NoAction);
        builder.HasOne<JobQuestion>().WithMany().HasForeignKey(x => x.JobQuestionId).OnDelete(DeleteBehavior.NoAction);
    }
}
