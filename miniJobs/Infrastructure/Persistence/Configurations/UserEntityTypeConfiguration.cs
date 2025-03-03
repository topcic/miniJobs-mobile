using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class UserEntityTypeConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.HasMany<Job>().WithOne().HasForeignKey(x => x.CreatedBy);
        builder.HasMany<Job>().WithOne().HasForeignKey(x => x.LastModifiedBy);
        builder.HasMany<Rating>().WithOne().HasForeignKey(x => x.CreatedBy);
        builder.HasMany<Rating>().WithOne().HasForeignKey(x => x.LastModifiedBy);
        builder.HasMany<SavedJob>().WithOne().HasForeignKey(x => x.CreatedBy);
        builder.HasMany<SavedJob>().WithOne().HasForeignKey(x => x.LastModifiedBy);
        builder.HasMany<RefreshToken>().WithOne().HasForeignKey(x => x.UserId);
    }
}