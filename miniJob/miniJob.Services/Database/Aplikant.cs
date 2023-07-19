using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class Aplikant
{
    public int Id { get; set; }

    public int? PrijedlogSatince { get; set; }

    public string? Opis { get; set; }

    public string? Iskustvo { get; set; }

    public string? Slika { get; set; }

    public string? NivoObrazovanja { get; set; }

    public string? Cv { get; set; }

    public int? OpstinaRodjenjaId { get; set; }

    public int? PreporukaId { get; set; }

    public virtual ICollection<ApliciraniPosao> ApliciraniPosaos { get; set; } = new List<ApliciraniPosao>();

    public virtual ICollection<AplikantPosaoTip> AplikantPosaoTips { get; set; } = new List<AplikantPosaoTip>();

    public virtual KorisnickiNalog IdNavigation { get; set; } = null!;

    public virtual Opstina? OpstinaRodjenja { get; set; }

    public virtual Preporuka? Preporuka { get; set; }

    public virtual ICollection<SpremljeniPosao> SpremljeniPosaos { get; set; } = new List<SpremljeniPosao>();
}
