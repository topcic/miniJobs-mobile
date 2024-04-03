using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class UserRoleEntityTypeConfiguration : IEntityTypeConfiguration<UserRole>
{
    public void Configure(EntityTypeBuilder<UserRole> builder)
    {
        builder.HasKey(x => new { x.UserId, x.RoleId });
        builder.HasOne<User>().WithOne().HasForeignKey<UserRole>(x => x.UserId).OnDelete(DeleteBehavior.NoAction);
        builder.HasOne<Role>().WithOne().HasForeignKey<UserRole>(x => x.RoleId).OnDelete(DeleteBehavior.NoAction);
    }
}
