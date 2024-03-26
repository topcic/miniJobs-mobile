using Domain.Interfaces;

namespace Domain.Entities;

[Table("refresh_tokens")]
public class RefreshToken : IEntity<string>
{

    [Key]
    [Column("id")]
    public string Id { get; set; }

    [Column("expire_in", TypeName = "timestamp without time zone")]
    public DateTime ExpireIn { get; set; }

    [Column("issued_at", TypeName = "timestamp without time zone")]
    public DateTime IssuedAt { get; set; }

    [Column("user_id")]
    public int? UserId { get; set; }

    [Column("token")]
    public string Token { get; set; }
}