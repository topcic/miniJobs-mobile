using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class AplikantPosaoTip
{
    public int Id { get; set; }

    public int AplikantId { get; set; }

    public int? Aplikantid1 { get; set; }

    public int PosaoTipId { get; set; }

    public int? PosaoTipid1 { get; set; }

    public virtual Aplikant? Aplikantid1Navigation { get; set; }

    public virtual PosaoTip? PosaoTipid1Navigation { get; set; }
}
