using BursaryFlow.Services;
using HouseServices.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);


// =========================================================
// MVC
// =========================================================

builder.Services.AddControllersWithViews();


// =========================================================
// ENTITY FRAMEWORK CORE
// =========================================================

builder.Services.AddDbContext<BursaryFlowDbContext>(options =>
    options.UseSqlServer(
        builder.Configuration.GetConnectionString(
            "BursaryFlowDB"
        )
    )
);


// =========================================================
// APPLICATION SERVICES
// =========================================================

builder.Services.AddScoped<StudentProfileService>();

builder.Services.AddScoped<BursaryKnowledgeService>();

builder.Services.AddScoped<BursaryMatchingService>();

builder.Services.AddScoped<DocumentQualityService>();

builder.Services.AddScoped<DocumentEnhancementService>();


// =========================================================
// SWAGGER
// =========================================================

builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen();


// =========================================================
// BUILD APPLICATION
// =========================================================

var app = builder.Build();


// =========================================================
// HTTP REQUEST PIPELINE
// =========================================================

if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");

    app.UseHsts();
}


// =========================================================
// HTTPS
// =========================================================

app.UseHttpsRedirection();


// =========================================================
// STATIC FILES
// =========================================================

app.UseStaticFiles();


// =========================================================
// ROUTING
// =========================================================

app.UseRouting();


// =========================================================
// AUTHORIZATION
// =========================================================

app.UseAuthorization();


// =========================================================
// MVC ROUTE
// =========================================================

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}"
);


// =========================================================
// API CONTROLLERS
// =========================================================

app.MapControllers();


// =========================================================
// SWAGGER
// =========================================================

app.UseSwagger();

app.UseSwaggerUI();


// =========================================================
// RUN
// =========================================================

app.Run();