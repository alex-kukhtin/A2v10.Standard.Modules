-- METADATA INIT
begin
-- TABLES
set nocount on;
declare @tables table([Id] uniqueidentifier, [Parent] uniqueidentifier, [ParentTable] uniqueidentifier,
   IsFolder bit, [Order] int null, [Schema] nvarchar(32),  [Name] nvarchar(128), [Kind] nvarchar(32), ItemsName nvarchar(128),
   ItemName nvarchar(128), TypeName nvarchar(128), EditWith nvarchar(16),ItemsLabel nvarchar(255),
   ItemLabel nvarchar(128),UseFolders bit, FolderMode nvarchar(16),[Type] nvarchar(32)
);

merge a2meta.[Catalog] as t
using @tables as s
on t.Id = s.Id
when matched then update set
   t.Parent = s.Parent,
   t.ParentTable = s.ParentTable,
   t.IsFolder = s.IsFolder,
   t.[Order] = s.[Order],
   t.[Schema] = s.[Schema],
   t.[Name] = s.[Name],
   t.[Kind] = s.[Kind],
   t.ItemsName = s.ItemsName,
   t.ItemName = s.ItemName,
   t.TypeName = s.TypeName,
   t.EditWith = s.EditWith,
   t.ItemsLabel = s.ItemsLabel,
   t.ItemLabel = s.ItemLabel,
   t.UseFolders = s.UseFolders,
   t.FolderMode = s.FolderMode,
   t.[Type] = s.[Type]
when not matched then
   insert (Id, Parent, ParentTable, IsFolder, [Order], [Schema], [Name], [Kind], ItemsName, ItemName, TypeName, EditWith, ItemsLabel, ItemLabel, UseFolders, FolderMode, [Type])
   values (s.Id, s.Parent, s.ParentTable, s.IsFolder, s.[Order], s.[Schema], s.[Name], s.[Kind], s.ItemsName, s.ItemName, s.TypeName, s.EditWith, s.ItemsLabel, s.ItemLabel, s.UseFolders, s.FolderMode, s.[Type]);
end
go