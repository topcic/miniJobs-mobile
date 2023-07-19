using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class Ocjena
{
    public int Id { get; set; }

    public int Vrijednost { get; set; }

    public string? Komentar { get; set; }

    public int OcjenjenId { get; set; }

    public int? Ocjenjenid1 { get; set; }

    public int OcjenjujeId { get; set; }

    public int ApliciraniPosaoId { get; set; }

    public virtual ApliciraniPosao ApliciraniPosao { get; set; } = null!;

    public virtual KorisnickiNalog? Ocjenjenid1Navigation { get; set; }

    public virtual KorisnickiNalog Ocjenjuje { get; set; } = null!;
}
