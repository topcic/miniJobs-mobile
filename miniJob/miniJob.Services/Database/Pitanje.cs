using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class Pitanje
{
    public int Id { get; set; }

    public string? Naziv { get; set; }

    public virtual ICollection<PonudjeniOdgovor> PonudjeniOdgovors { get; set; } = new List<PonudjeniOdgovor>();

    public virtual ICollection<PosaoPitanje> PosaoPitanjes { get; set; } = new List<PosaoPitanje>();
}
