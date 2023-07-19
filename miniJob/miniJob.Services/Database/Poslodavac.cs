using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class Poslodavac
{
    public int Id { get; set; }


    public string? Adresa { get; set; }
    public string? NazivFirme { get; set; }
    public virtual KorisnickiNalog IdNavigation { get; set; } = null!;

    public virtual ICollection<Posao> Posaos { get; set; } = new List<Posao>();
}
