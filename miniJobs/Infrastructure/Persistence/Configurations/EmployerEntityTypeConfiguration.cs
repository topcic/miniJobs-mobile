using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class EmployerEntityTypeConfiguration : IEntityTypeConfiguration<Employer>
{
    public void Configure(EntityTypeBuilder<Employer> builder)
    {

        builder.HasOne(e => e.User) // Specify the navigation property explicitly
            .WithOne()
            .HasForeignKey<Employer>(e => e.Id) // Use the Employer.Id as the foreign key to User
            .OnDelete(DeleteBehavior.NoAction);
    }
}
