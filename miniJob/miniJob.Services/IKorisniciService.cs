using miniJob.Model.Requests;
using miniJob.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Services
{
    public interface IKorisniciService:IService<Model.KorisnickiNalog,Model.SearchObjects.KorisnikSearchObject>
    {

        Model.KorisnickiNalog Insert(KorisniciInsertRequest request);
        Model.KorisnickiNalog Update(int id, KorisniciUpdateRequest request);
    }
}
