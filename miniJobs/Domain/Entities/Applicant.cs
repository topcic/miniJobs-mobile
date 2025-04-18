﻿using Domain.Interfaces;

namespace Domain.Entities;
[Table("applicants")]
public class Applicant : IEntity<int>
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("cv")]
    public byte[]? Cv { get; set; }

    [Column("experience")]
    public string? Experience { get; set; }

    [Column("description")]
    public string? Description { get; set; }

    [Column("wage_proposal")]
    public decimal? WageProposal { get; set; }

    public User User { get; set; }
    public ICollection<ApplicantJobType> ApplicantJobTypes { get; set; }
    [NotMapped]
    public decimal AverageRating { get; set; }
    [NotMapped]
    public int NumberOfFinishedJobs { get; set; }
}