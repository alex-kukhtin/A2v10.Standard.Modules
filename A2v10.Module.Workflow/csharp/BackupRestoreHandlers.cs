// Copyright © 2025 Oleksandr Kukhtin. All rights reserved.

using System.Dynamic;
using System.IO.Compression;

using Newtonsoft.Json;

using A2v10.Data.Interfaces;
using A2v10.Infrastructure;

namespace A2v10.Module.Workflow;

internal class LoadSaveParams
{
    public const String CONTENT = "content.json";
}

public class BackupHandler(IServiceProvider _serviceProvider) : IClrInvokeBlob
{
    private readonly IDbContext _dbContext = _serviceProvider.GetRequiredService<IDbContext>();

    public async Task<InvokeBlobResult> InvokeAsync(ExpandoObject args)
    {
        var ids = args.Get<String>("Ids");
        var prms = new ExpandoObject()
        {
            {"UserId", args.Get<Int64>("UserId")},
            {"Ids", ids},
        };
        var dm = await _dbContext.LoadModelAsync(null, "wfadm.[Catalog.Backup]", prms)
            ?? throw new InvalidOperationException("Model not found");

        var workflows = dm.Eval<List<ExpandoObject>>("Workflows");
        var data = dm.Eval<List<ExpandoObject>>("Data")
            ?? throw new InvalidOperationException("Data not found");

        var jsonSource = new ExpandoObject()
        {
            { "Workflows", workflows },
        };
        var json = JsonConvert.SerializeObject(jsonSource, new JsonSerializerSettings
        {
            NullValueHandling = NullValueHandling.Ignore,
            DefaultValueHandling = DefaultValueHandling.Ignore,
            Formatting = Formatting.Indented
        });

        using var ms = new MemoryStream();
        using (var archive = new ZipArchive(ms, ZipArchiveMode.Create)) 
        {
            var entry = archive.CreateEntry(LoadSaveParams.CONTENT, CompressionLevel.Fastest);
            using (var wr = new StreamWriter(entry.Open()))
                wr.Write(json);
            foreach (var d in data)
            {
                var wfName = $"{d.Get<String>("Id")}.bpmn";
                var bodyEntry = archive.CreateEntry(wfName, CompressionLevel.Fastest);
                using (var wr = new StreamWriter(bodyEntry.Open()))
                    wr.Write(d.Get<String>("Body"));
                var svgName = $"{d.Get<String>("Id")}.svg";
                var svgEntry = archive.CreateEntry(svgName, CompressionLevel.Fastest);
                using (var wr = new StreamWriter(svgEntry.Open()))
                    wr.Write(d.Get<String>("Svg"));
            }
        }

        return new InvokeBlobResult
        {
            Stream = ms.ToArray(),
            Mime = MimeTypes.Application.Zip,
            Name = "workflows.zip"
        };
    }
}

public class RestoreHandler(IServiceProvider _serviceProvider) : IClrInvokeTarget
{
    private readonly IDbContext _dbContext = _serviceProvider.GetRequiredService<IDbContext>();
    public async Task<Object> InvokeAsync(ExpandoObject args)
    {
        var userId = args.Get<Int64>("UserId");
        var blobUpdate = args.Get<IBlobUpdateInfo>("Blob") ??
                throw new InvalidOperationException("Blob is null");
        if (blobUpdate.Stream == null)
            throw new InvalidOperationException("Blob.Stream is null");
        String? json = null;
        using (var archive = new ZipArchive(blobUpdate.Stream, ZipArchiveMode.Read))
        {
            var entry = archive.GetEntry(LoadSaveParams.CONTENT)
                ?? throw new InvalidOperationException("No CONTENT entry");
            using (var sr = new StreamReader(entry.Open()))
                json = sr.ReadToEnd();
            var data = JsonConvert.DeserializeObject<ExpandoObject>(json);
            var items = data?.Eval<List<Object>>("Workflows")?.Cast<ExpandoObject>()
                ?? throw new InvalidOperationException("No Workflows in CONTENT");
            foreach (var ent in archive.Entries.Where(x => x.Name != LoadSaveParams.CONTENT))
            {
                String text;
                using (var sr = new StreamReader(ent.Open()))
                    text = sr.ReadToEnd();
                var id = Path.GetFileNameWithoutExtension(ent.Name);
                var elem = items.FirstOrDefault(x => x.Get<String>("Id") == id)
                    ?? throw new InvalidOperationException($"No workflow with Id {id} in CONTENT");
                if (ent.Name.EndsWith(".bpmn"))
                    elem.Set("Body", text);
                else if (ent.Name.EndsWith(".svg"))
                    elem.Set("Svg", text);
                else
                    throw new InvalidOperationException($"Unknown file type {ent.Name}");
            }
            await _dbContext.SaveModelAsync(null, "wfadm.[Catalog.Restore.Update]", data, 
                new ExpandoObject() {
                    { "UserId", userId },
                }
            );
        }
        return new ExpandoObject();
    }
}
