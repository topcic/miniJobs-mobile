using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class ApliciraniPosao
{
    public int Id { get; set; }

    public string? Status { get; set; }

    public DateTime DatumApliciranja { get; set; }

    public int AplikantId { get; set; }

    public int PosaoId { get; set; }

    public virtual Aplikant Aplikant { get; set; } = null!;

    public virtual ICollection<Ocjena> Ocjenas { get; set; } = new List<Ocjena>();

    public virtual Posao Posao { get; set; } = null!;
}
