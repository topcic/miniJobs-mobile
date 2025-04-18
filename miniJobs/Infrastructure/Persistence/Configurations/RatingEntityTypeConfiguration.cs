﻿using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class RatingEntityTypeConfiguration : IEntityTypeConfiguration<Rating>
{
    public void Configure(EntityTypeBuilder<Rating> builder)
    {
        builder.HasOne<JobApplication>().WithMany().HasForeignKey(x => x.JobApplicationId).OnDelete(DeleteBehavior.NoAction);
        builder.HasOne<User>().WithMany().HasForeignKey(x => x.CreatedBy);
        builder.HasOne<User>().WithMany().HasForeignKey(x => x.LastModifiedBy);
    }
}