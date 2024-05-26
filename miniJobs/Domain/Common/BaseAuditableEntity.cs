using System.Runtime.Serialization;

namespace Domain.Common;

public abstract class BaseAuditableEntity
{
    [Column("created")]
    public DateTime Created { get; set; }

    [IgnoreDataMember]
    [Column("created_by")]
    public int? CreatedBy { get; set; }

    [Column("last_modified")]
    public DateTime? LastModified { get; set; }

    [IgnoreDataMember]
    [Column("last_modified_by")]
    public int? LastModifiedBy { get; set; }
}