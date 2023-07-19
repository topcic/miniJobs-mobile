using Microsoft.AspNetCore.Mvc;
using miniJob.Model;
using miniJob.Model.Requests;
using miniJob.Services;
using miniJob.Services.Database;

namespace miniJob.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class KorisniciController : ControllerBase
    {
        private readonly IKorisniciService _service;
        private readonly ILogger<KorisniciController> _logger;

        public KorisniciController(ILogger<KorisniciController> logger,IKorisniciService service)
        {
            _logger = logger;
            _service = service;
        }
        [HttpGet()]
        public IEnumerable<Model.KorisnickiNalog> Get()
        {
            return _service.Get();
        }
        [HttpPost]
        public Model.KorisnickiNalog Insert(KorisniciInsertRequest request)
        {
            return _service.Insert(request);
        }

    }
}