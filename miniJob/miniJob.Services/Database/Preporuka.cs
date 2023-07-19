using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class Preporuka
{
    public int Id { get; set; }

    public int OpstinaId { get; set; }

    public virtual ICollection<Aplikant> Aplikants { get; set; } = new List<Aplikant>();

    public virtual Opstina Opstina { get; set; } = null!;

    public virtual ICollection<PreporukaTipPosla> PreporukaTipPoslas { get; set; } = new List<PreporukaTipPosla>();
}
