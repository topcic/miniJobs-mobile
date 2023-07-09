using miniJob.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Services
{
    public interface IPosaoService
    {
        IList<Posao> Get();
    }
}
