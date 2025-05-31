// Copyright © 2025 Oleksandr Kukhtin. All rights reserved.

using A2v10.Infrastructure;
using A2v10.Scheduling;
using A2v10.Services;
using A2v10.Workflow.Engine;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace WebApp;

public class Startup(IConfiguration configuration)
{
    public IConfiguration Configuration { get; } = configuration;

    public void ConfigureServices(IServiceCollection services)
    {
        services.UseAppMetdata();

        //services.AddSingleton<ILicenseManager, NullLicenseManager>();

        services.UsePlatform(Configuration);

        services.AddWorkflowEngineScoped()
        .AddInvokeTargets(a =>
        {
            a.RegisterEngine<WorkflowInvokeTarget>("Workflow", InvokeScope.Scoped);
        });

        services.UseScheduling(Configuration, factory =>
        {
            // job handlers
            factory.RegisterJobHandler<WorkflowPendingJobHandler>("WorkflowPending");
        });
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        app.ConfigurePlatform(env, Configuration);
    }
}
