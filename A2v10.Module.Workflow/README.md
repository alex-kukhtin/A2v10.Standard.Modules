# A2v10.Module.Workflow

Workflow UI module for A2v10 application

# How to use

1. Install workflow modules (WebApp):
```xml
<ItemGroup>
	<PackageReference Include="A2v10.Workflow.WebAssets" Version="10.1.8115" />
	<PackageReference Include="A2v10.Workflow.Engine" Version="10.1.8227" />
	<PackageReference Include="A2v10.Scheduling" Version="10.1.8547" />
    <!-- This module  -->
	<PackageReference Include="A2v10.Module.Workflow" Version="10.1.1035" />
</ItemGroup>
```
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

4. Run the *WebApp/_assets/sql/a2v10_workflow.sql* script to create workflow tables, views, stored procedures, etc.
5. Run the *WebApp/_assets/sql/a2v10_workflow_module.sql* script to create workflow UI assets.

# Available UI Endpoints

- `page:/$workflow/catalog/index/0` - workflow catalog
- `page:/$workflow/instance/index/0` - workflow instances
- `page:/$workflow/autostart/index/0` - autostart catalog

# Available Dialogs

- `/$workflow/instance/show/{id}` - show workflow instance

# Feedback

**A2v10.Module.Workflow** is released as open source under the MIT license.
Bug reports and contributions are welcome at the GitHub repository.
