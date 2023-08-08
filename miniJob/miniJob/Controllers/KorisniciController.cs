using Microsoft.AspNetCore.Mvc;
using miniJob.Model;
using miniJob.Model.Requests;
using miniJob.Services;
using miniJob.Services.Database;

namespace miniJob.Controllers
{
    [ApiController]

    public class KorisniciController : BaseContoller<Model.KorisnickiNalog, Model.SearchObjects.KorisnikSearchObject>
    {
        public KorisniciController(ILogger<BaseContoller<Model.KorisnickiNalog, Model.SearchObjects.KorisnikSearchObject>> logger, IKorisniciService service) : base(logger, service)
        {
        }
    }
}