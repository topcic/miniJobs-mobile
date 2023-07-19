using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class PosaoTip
{
    public int Id { get; set; }

    public string? Naziv { get; set; }

    public virtual ICollection<AplikantPosaoTip> AplikantPosaoTips { get; set; } = new List<AplikantPosaoTip>();

    public virtual ICollection<Posao> Posaos { get; set; } = new List<Posao>();

    public virtual ICollection<PreporukaTipPosla> PreporukaTipPoslas { get; set; } = new List<PreporukaTipPosla>();
}
