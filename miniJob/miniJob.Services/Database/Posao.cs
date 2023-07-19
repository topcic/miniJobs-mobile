using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class Posao
{
    public int Id { get; set; }

    public string? Naziv { get; set; }

    public string? Opis { get; set; }

    public string? Adresa { get; set; }

    public string? Status { get; set; }

    public DateTime DatumKreiranja { get; set; }

    public DateTime Deadline { get; set; }

    public int Cijena { get; set; }

    public int BrojAplikanata { get; set; }

    public int OpstinaId { get; set; }

    public int PosaoTipId { get; set; }

    public int PoslodavacId { get; set; }

    public virtual ICollection<ApliciraniPosao> ApliciraniPosaos { get; set; } = new List<ApliciraniPosao>();

    public virtual Opstina Opstina { get; set; } = null!;

 

    public virtual ICollection<PosaoPitanje> PosaoPitanjes { get; set; } = new List<PosaoPitanje>();

    public virtual PosaoTip PosaoTip { get; set; } = null!;

    public virtual Poslodavac Poslodavac { get; set; } = null!;

    public virtual ICollection<SpremljeniPosao> SpremljeniPosaos { get; set; } = new List<SpremljeniPosao>();
}
