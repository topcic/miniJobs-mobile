using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;


public class QuestionAnswerEntityTypeConfiguration : IEntityTypeConfiguration<QuestionAnswer>
{
    public void Configure(EntityTypeBuilder<QuestionAnswer> builder)
    {
        builder.HasOne<ProposedAnswer>().WithOne().HasForeignKey<QuestionAnswer>(x => x.ProposedAnswerId);
        builder.HasOne<Question>().WithOne().HasForeignKey<QuestionAnswer>(x => x.QuestionId);
    }
}
