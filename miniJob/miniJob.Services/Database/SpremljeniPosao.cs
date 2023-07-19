using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class SpremljeniPosao
{
    public int Id { get; set; }

    public int Status { get; set; }

    public int AplikantId { get; set; }

    public int PosaoId { get; set; }

    public virtual Aplikant Aplikant { get; set; } = null!;

    public virtual Posao Posao { get; set; } = null!;
}
