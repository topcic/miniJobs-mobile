using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class PreporukaTipPosla
{
    public int Id { get; set; }

    public int PosaoTipId { get; set; }

    public int PreporukaId { get; set; }

    public virtual PosaoTip PosaoTip { get; set; } = null!;

    public virtual Preporuka Preporuka { get; set; } = null!;
}
