namespace Domain.Entities;
[Table("user_roles")]

public class UserRole
{
    [Key]
    [Column("user_id")]
    public int UserId { get; set; }
   
    [Key]
    [Column("role_id")]
    public string RoleId { get; set; }

}
