# A2v10.Module.Workflow

Workflow UI module for A2v10 application

# How to use

1. Install workflow modules (WebApp):
```xml
<ItemGroup>
	<PackageReference Include="A2v10.Scheduling" Version="10.1.8551" />
	<PackageReference Include="A2v10.Module.Workflow" Version="10.1.1038" />
</ItemGroup>
```
Dependent Modules (*A2v10.Workflow.WebAssets*, *A2v10.Workflow.Engine*, *A2v10.Scheduling*) will be installed automatically.

2. Add the Workflow engine to the service collection and register the engine target.
Add Scheduler to the service collection and register the Workflow Pending job handler.
```csharp
services.AddWorkflowEngineScoped()
.AddInvokeTargets(a =>
{
    a.RegisterEngine<WorkflowInvokeTarget>("Workflow", InvokeScope.Scoped);
});

services.UseScheduling(Configuration, factory =>
{
    factory.RegisterJobHandler<WorkflowPendingJobHandler>("WorkflowPending");
});
```

3. Add the Scheduler configuration to the appsettings.json
```json
"Scheduler": {
    "Jobs": [
        {
            "Id": "WorkflowPending",
            "Handler": "WorkflowPending",
            "Cron": "0 * * ? * *" /* every minute */
        }
    ]
}
```

4. Run the *WebApp/_assets/sql/a2_scheduling.sql* script to create scheduling tables, views, stored procedures, etc.
5. Run the *WebApp/_assets/sql/a2v10_workflow.sql* script to create workflow tables, views, stored procedures, etc.
6. Run the *WebApp/_assets/sql/a2v10_workflow_module.sql* script to create workflow UI assets.

# Available UI Endpoints

- `page:/$workflow/catalog/index/0` - workflow catalog
- `page:/$workflow/instance/index/0` - workflow instances
- `page:/$workflow/autostart/index/0` - autostart catalog

# Available Dialogs

- `/$workflow/instance/show/{id}` - show workflow instance
- `/$workflow/instance/log/{id}` - show instance log
- `/$workflow/instance/variables/{id}` - show instance variables
- `/$workflow/instance/events/{id}` - show instance events

# Feedback

**A2v10.Module.Workflow** is released as open source under the MIT license.
Bug reports and contributions are welcome at the GitHub repository.
