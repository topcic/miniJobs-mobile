using miniJob.Model.Requests;
using miniJob.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Services
{
    public interface IKorisniciService
    {
        List<Model.KorisnickiNalog> Get();
        Model.KorisnickiNalog Insert(KorisniciInsertRequest request);
    
    }
}
