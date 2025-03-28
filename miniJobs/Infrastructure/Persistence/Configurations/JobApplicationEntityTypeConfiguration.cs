﻿using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace Infrastructure.Persistence.Configurations;

public class JobApplicationEntityTypeConfiguration : IEntityTypeConfiguration<JobApplication>
{
    public void Configure(EntityTypeBuilder<JobApplication> builder)
    {
        builder.HasKey(x => x.Id);
  
        builder.HasOne<User>().WithMany().HasForeignKey(x => x.LastModifiedBy);
        builder.HasOne(x => x.JobReference)
              .WithMany()
              .HasForeignKey(x => x.JobId)
              .OnDelete(DeleteBehavior.NoAction);
        builder.HasOne(x => x.User)
      .WithMany()
      .HasForeignKey(x => x.CreatedBy);
    }
}