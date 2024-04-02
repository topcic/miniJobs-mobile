using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class ApplicantEntityTypeConfiguration : IEntityTypeConfiguration<Applicant>
{
    public void Configure(EntityTypeBuilder<Applicant> builder)
    {
        builder.HasOne<User>().WithOne().HasForeignKey<Applicant>(x => x.Id);
        builder.HasOne<Document>().WithMany().HasForeignKey(x => x.PhotoId).IsRequired();
        builder.HasOne<Document>().WithMany().HasForeignKey(x => x.CvId).IsRequired();
    }
}