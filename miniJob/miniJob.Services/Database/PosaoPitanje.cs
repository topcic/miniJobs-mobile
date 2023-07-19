using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class PosaoPitanje
{
    public int Id { get; set; }

    public int PitanjeId { get; set; }

    public int PosaoId { get; set; }

    public virtual Pitanje Pitanje { get; set; } = null!;

    public virtual ICollection<PitanjeOdgovor> PitanjeOdgovors { get; set; } = new List<PitanjeOdgovor>();

    public virtual Posao Posao { get; set; } = null!;
}
