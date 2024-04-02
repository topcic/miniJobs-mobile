using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class ProposedAnswerEntityTypeConfiguration : IEntityTypeConfiguration<ProposedAnswer>
{
    public void Configure(EntityTypeBuilder<ProposedAnswer> builder)
    {
        builder.HasOne<Question>().WithOne().HasForeignKey<ProposedAnswer>(x => x.QuestionId);
    }
}