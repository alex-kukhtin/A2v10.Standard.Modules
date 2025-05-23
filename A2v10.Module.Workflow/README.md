﻿# A2v10.Module.Workflow

Workflow UI module for A2v10 application

# How to use

1. Install workflow modules (WebApp):
```xml
<ItemGroup>
	<PackageReference Include="A2v10.Workflow.WebAssets" Version="10.1.8112" />
	<PackageReference Include="A2v10.Workflow.Engine" Version="10.1.8221" />
	<PackageReference Include="A2v10.Scheduling" Version="10.1.8547" />
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

4. Connect scripts in *MainApp/_layout/scripts.html*:
```html
<script type="text/javascript" src="/scripts/bpmnfull.min.js?v=1.1.8112"></script>
```
Check the version of bpmnfull.min.js in your project. It should be the same as the package version.


5. Connect stylesheet in *MainApp/_layout/styles.html*:
```html
<link rel="stylesheet" href="/css/bpmnfull.min.css?v=1.1.8112">
```
Check the version of bpmnfull.min.css in your project. It should be the same as the package version.

6. Run the *WebApp/_assets/sql/a2v10_workflow.sql* script to create workflow tables, views, stored procedures, etc.
7. Run the *WebApp/_assets/sql/a2v10_workflow_module.sql* script to create workflow UI assets.


 # Feedback

**A2v10.Module.Workflow** is released as open source under the MIT license.
Bug reports and contributions are welcome at the GitHub repository.
