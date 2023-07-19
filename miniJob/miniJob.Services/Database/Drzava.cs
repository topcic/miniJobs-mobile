using System;
using System.Collections.Generic;

namespace miniJob.Services.Database;

public partial class Drzava
{
    public int Id { get; set; }

    public string? Naziv { get; set; }

    public virtual ICollection<Opstina> Opstinas { get; set; } = new List<Opstina>();
}
