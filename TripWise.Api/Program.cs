var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();

// (opcional - swagger depois)
// builder.Services.AddEndpointsApiExplorer();
// builder.Services.AddSwaggerGen();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    // swagger depois
}

app.UseHttpsRedirection();

app.MapControllers();

app.Run();