﻿using Domain.Enums;

namespace Domain.Entities;


[Table("users")]
public class User
{
    [Key]
    [Column("id")]
    public int Id { get; set; }

    [Column("first_name")]
    public string FirstName { get; set; }

    [Column("last_name")]
    public string LastName { get; set; }

    [Column("user_name")]
    public string? UserName { get; set; }

    [Column("email")]
    public string Email { get; set; }

    [Column("phone_number")]
    public string? PhoneNumber { get; set; }

    [Column("gender")]
    public Gender? Gender { get; set; }

    [Column("date_of_birth")]
    public DateTime? DateOfBirth { get; set; }

    [Column("city_id")]
    public int? CityId { get; set; }

    [Column("deleted")]
    public bool Deleted { get; set; }

    [Column("account_confirmed")]
    public bool AccountConfirmed { get; set; } = false;

    [Column("password_hash")]
    public string? PasswordHash { get; set; }

    [Column("confirmation_code")]
    public Guid? ConfirmationCode { get; set; }

    [Column("access_failed_count")]
    public int AccessFailedCount { get; set; }

    [Column("created", TypeName = "timestamp without time zone")]
    public DateTime Created { get; set; }

    [Column("created_by")]
    public int? CreatedBy { get; set; }
}