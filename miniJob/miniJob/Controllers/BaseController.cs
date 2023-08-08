using Microsoft.AspNetCore.Mvc;
using miniJob.Services;

namespace miniJob.Controllers
{

    [Route("[controller]")]
    public class BaseContoller<T,TSearch> : ControllerBase where T : class where TSearch : Model.SearchObjects.BaseSearchObject
    {
        private readonly IService<T, TSearch> _service;
        private readonly ILogger<BaseContoller<T, TSearch>> _logger;

        public BaseContoller(ILogger<BaseContoller<T, TSearch>> logger, IService<T, TSearch> service)
        {
            _logger = logger;
            _service = service;
        }
        [HttpGet()]
        public async Task<IEnumerable<T>> Get( [FromQuery]TSearch search=null)
        {
            return await _service.Get(search);
        }
      

        [HttpGet("{id}")]
        public async Task<T> GetById(int id)
        {
            return await _service.GetById(id);
        }
    }
    }
