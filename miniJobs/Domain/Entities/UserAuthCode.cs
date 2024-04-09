
using Domain.Entities;
using Domain.Interfaces;

namespace Data.Entities
{
    [Table("user_auth_codes")]
    public class UserAuthCode : IEntity<int>
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("user_id")]
        public int UserId { get; set; }

        public User User { get; set; }

        [Column("code")]
        public string Code { get; set; }

        [Column("generated_at")]
        public DateTime GeneratedAt { get; set; }

        [Column("used")]
        public bool Used { get; set; }
    }
}
