using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class ApplicantEntityTypeConfiguration : IEntityTypeConfiguration<Applicant>
{
    public void Configure(EntityTypeBuilder<Applicant> builder)
    {
        builder.HasOne<User>().WithOne().HasForeignKey<Applicant>(x => x.Id).OnDelete(DeleteBehavior.NoAction);
    }
}