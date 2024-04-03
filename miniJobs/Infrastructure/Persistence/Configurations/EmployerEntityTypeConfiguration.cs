using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class EmployerEntityTypeConfiguration : IEntityTypeConfiguration<Employer>
{
    public void Configure(EntityTypeBuilder<Employer> builder)
    {
        builder.HasOne<User>().WithOne().HasForeignKey<Employer>(x => x.Id).OnDelete(DeleteBehavior.NoAction);
    }
}
