using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class PonudjeniOdgovor
{
    public int Id { get; set; }

    public string? Odgovor { get; set; }

    public int PitanjeId { get; set; }

    public virtual Pitanje Pitanje { get; set; } = null!;

    public virtual ICollection<PitanjeOdgovor> PitanjeOdgovors { get; set; } = new List<PitanjeOdgovor>();
}
