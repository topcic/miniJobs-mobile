using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class ApplicantEntityTypeConfiguration : IEntityTypeConfiguration<Applicant>
{
    public void Configure(EntityTypeBuilder<Applicant> builder)
    {
        builder.HasOne(a => a.User)
               .WithOne()
               .HasForeignKey<Applicant>(a => a.Id)
               .OnDelete(DeleteBehavior.NoAction);
    }
}