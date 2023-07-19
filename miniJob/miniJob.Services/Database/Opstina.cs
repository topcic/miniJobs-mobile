using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class Opstina
{
    public int Id { get; set; }

    public string? Description { get; set; }

    public int DrzavaId { get; set; }

    public virtual ICollection<Aplikant> Aplikants { get; set; } = new List<Aplikant>();

    public virtual Drzava Drzava { get; set; } = null!;

    public virtual ICollection<Posao> Posaos { get; set; } = new List<Posao>();

    public virtual ICollection<Preporuka> Preporukas { get; set; } = new List<Preporuka>();
}
