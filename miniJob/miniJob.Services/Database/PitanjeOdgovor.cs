using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class PitanjeOdgovor
{
    public int Id { get; set; }

    public int PosaoPitanjeId { get; set; }

    public int PonudjeniOdgovorId { get; set; }

    public virtual PonudjeniOdgovor PonudjeniOdgovor { get; set; } = null!;

    public virtual PosaoPitanje PosaoPitanje { get; set; } = null!;
}
