using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.SqlServer.Query.Internal;
using miniJob.Model.SearchObjects;
using miniJob.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace miniJob.Services
{
    public class BaseService<T,TDb, TSearch> :IService<T,TSearch> where TDb : class where T : class where TSearch : BaseSearchObject
    {
      protected  miniJobsContext _db;
        public IMapper _mapper { get; set; }
        public BaseService(miniJobsContext miniJobsContext, IMapper mapper)
        {
            _db = miniJobsContext;
            _mapper = mapper;
        }

        public  virtual async Task<List<T>> Get(TSearch? search = null)
        {
            var query = _db.Set<TDb>().AsQueryable();
            query= AddFilter(query, search);
            query = AddInclude(query, search);
            if (search?.Page.HasValue==true && search?.PageSize.HasValue==true)
            {
                query=query.Take(search.PageSize.Value).Skip(search.Page.Value* search.PageSize.Value);
            }
            var list=await query.ToListAsync();

            return _mapper.Map<List<T>>(list);
        }

        public virtual IQueryable<TDb> AddFilter(IQueryable<TDb> query,TSearch? search=null)
        {
            return query;
        }
        public virtual IQueryable<TDb> AddInclude(IQueryable<TDb> query, TSearch? search = null)
        {
            return query;
        }

        public async Task<T> GetById(int id)
        {
           var entity=await _db.Set<TDb>().FindAsync(id);

            return _mapper.Map<T>(entity);
        }

      
    }
}
