using Application.Common.Middlewares;
using Hangfire;
using NLog.Web;
using WebAPI.Extensions;

var builder = WebApplication.CreateBuilder(args);

builder.Logging.ClearProviders();
builder.Host.UseNLog();
// Add services to the container.
builder.Services.AddApplicationServices();
builder.Services.AddInfrastructureServices(builder.Configuration);
builder.Services.AddWebAPIServices(builder.Configuration);
builder.Services.AddJobManagerAndServices();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();

    //app.UseHangfireDashboard(string.Empty, new DashboardOptions()
    //{
    //    Authorization = []
    //});
}
app.StartRecurringJobs();

app.UseHttpsRedirection();

app.UseAuthentication();
app.UseAuthorization();
app.UseRequestLocalization();
app.UseMiddleware<UserMiddleware>();
app.UseMiddleware<UnhandledExceptionMiddleware>();
app.UseCors("miniJobsCors");

app.MapControllers();

app.ExecuteMigrations();


app.Run();
