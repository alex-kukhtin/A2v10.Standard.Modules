-- Application Designer
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'cat')
	exec sp_executesql N'create schema cat authorization dbo';
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'doc')
	exec sp_executesql N'create schema doc authorization dbo';
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'jrn')
	exec sp_executesql N'create schema jrn authorization dbo';
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'op')
	exec sp_executesql N'create schema op authorization dbo';
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'enm')
	exec sp_executesql N'create schema enm authorization dbo';
go
------------------------------------------------
begin
	set nocount on;

	if not exists (select * from a2ui.Menu)
		insert into a2ui.Menu(Id, Parent, [Name], Icon, [Order], [ClassName]) values
		(N'00000000-0000-0000-0000-000000000000', null, N'Main', null, 0, null),
		(N'02393194-2D0C-4651-B7D0-C64A9B6E0A69', N'00000000-0000-0000-0000-000000000000', null, null, 890, N'grow'),
		(N'9F3B38D6-2344-4BD7-BEFA-47819E0EC2FF', N'00000000-0000-0000-0000-000000000000', N'@[Settings]', N'gear-outline', 900, null);
end
go
------------------------------------------------
create or alter procedure a2meta.[Config.Index]
@UserId bigint
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @root uniqueidentifier;
	select @root = Id from a2meta.[Catalog] where [Kind] = N'root' and Id = [Parent];

	select [Elems!TElem!Tree] = null, [Id!!Id] = c.Id, [Name!!Name] = c.[Name], c.IsFolder, c.[Schema], 
		Kind, ParentTable,
		[Items!TElem!Items] = null,
		[HasChildren!!HasChildren] = case when exists(select * from a2meta.[Catalog] ch where ch.Parent = c.Id) then 1 else 0 end,
		[!TElem.Items!ParentId] = nullif(Parent, @root)
	from a2meta.[Catalog] c
	where IsFolder = 1 or Kind = N'app'
	order by [Order];
end
go
------------------------------------------------
create or alter procedure a2meta.[Config.Expand]
@UserId bigint,
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	with T as (
		select [Id], [Parent], 
			IsFolder, [Name], [Schema], ParentTable, Kind, [Level] = 0, [Order]
		from a2meta.[Catalog] where Parent = @Id
		union all 
		select c.[Id], c.[Parent], c.IsFolder, c.[Name], c.[Schema], c.ParentTable, c.Kind, [Level] = T.[Level] + 1, c.[Order] 
		from a2meta.[Catalog] c inner join T on c.Parent = T.Id
	)
	select [Items!TElem!Tree] = null, [Id!!Id] = Id, [Name!!Name] = [Name], IsFolder, [Schema], 
		Kind, ParentTable,
		[Items!TElem!Items] = null,
		[!TElem.Items!ParentId] = nullif(Parent, @Id)
	from T
	order by [Level], 
		case when [Schema] = 'ui' then cast([Order] as nvarchar(255)) else [Name] end;
end
go
------------------------------------------------
create or alter procedure a2meta.[Config.CreateItem]
@UserId bigint,
@Parent uniqueidentifier,
@Schema nvarchar(32),
@Name nvarchar(255),
@Kind nvarchar(32)
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;

	
	declare @Id uniqueidentifier = newid();
	declare @order int;
	select @order = isnull(max([Order]), 0) + 1 from a2meta.[Catalog] where Parent = @Parent;

	insert into a2meta.[Catalog] (Id, Parent, [Schema], [Name], Kind, EditWith, [Order])
	values (@Id, @Parent, @Schema, @Name, @Kind, 
		case @Schema 
			when  N'doc' then N'Page'
			when  N'op' then N'Page'
			else N'Dialog' 
		end,
		@order
	);

	insert into a2meta.Columns ([Table], [Name], [DataType], [MaxLength], Reference, [Role], [Order], [Required], [Total])
	select @Id, dc.[Name], dc.[DataType], dc.[MaxLength],
		Reference = case dc.Ref 
			when N'self' then @Id
			when N'parent' then @Parent
			else null
		end,
		dc.[Role], dc.[Order], dc.[Required], dc.[Total]
	from a2meta.DefaultColumns dc
	where [Schema] = @Schema and Kind = @Kind
	order by [Order];

	insert into a2meta.MenuItems(Interface, [Name], [Order])
	select @Id, [Name], [Order] from a2meta.DefaultSections where [Schema] = @Schema;

	select [Elem!TElem!Object] = null, [Id!!Id] = Id, IsFolder, Kind, [Schema], [Name]
	from a2meta.[Catalog] where Id = @Id;
end
go
------------------------------------------------
create or alter procedure a2meta.[Config.DeleteItem]
@UserId bigint,
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;

	-- table and its details
	declare @tables a2sys.[Guid.TableType];
	insert into @tables(Id)
	select Id from a2meta.[Catalog] where Id = @Id or Parent = @Id;

	begin tran;

	delete from a2meta.ApplyMapping
	from a2meta.ApplyMapping am
		inner join a2meta.Columns c on c.Id in (am.Source, am.[Target])
		inner join @tables t on t.Id in (c.[Table], c.[Reference]);

	delete from a2meta.ApplyMapping
	from a2meta.ApplyMapping am
		inner join a2meta.Apply a on am.Apply = a.Id
		inner join @tables t on t.Id in (a.Details);

	delete from a2meta.Apply
	from a2meta.Apply a inner join @tables t on t.Id in (a.Details);

	delete from a2meta.Columns 
	from a2meta.Columns c inner join @tables t on t.Id in (c.[Table], c.[Reference])

	delete from a2meta.[Catalog] 
	from a2meta.[Catalog] c inner join @tables t on c.Id = t.Id

	commit tran;
			
end
go
------------------------------------------------
create or alter procedure a2meta.[Application.Load]
@UserId bigint,
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	
	select [App!TApp!Object] = null, [Id!!Id] = Id, [Name!!Name] = [Name], Title, IdDataType,
		[Memo], [Version]
	from a2meta.[Application] where Id = @Id;
end
go
------------------------------------------------
create or alter procedure a2meta.[Table.Load]
@UserId bigint,
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Table!TTable!Object] = null, [Id!!Id] = t.Id, [Name!!Name] = t.[Name], t.[Schema], t.Kind, t.[Type],
		t.ItemsName, t.ItemName, t.TypeName, t.EditWith, t.ItemLabel, t.ItemsLabel, t.Source,  t.UseFolders, t.FolderMode,
		[ParentTable.Id!TPTable!Id] = t.ParentTable, [ParentTable.Name!TPTable!Name] = a2meta.fn_TableFullName(p.[Schema], p.[Name]),
		[ParentTable.Endpoint!TPTable!] = lower(a2meta.fn_Schema2Text(p.[Schema]) + '/' + p.[Name]),
		[ParentElem.Schema!TPElem!] = x.[Schema], [ParentElem.Name!TPElem!] = x.[Name],
		[Columns!TColumn!Array] = null,
		[Apply!TApply!Array] = null,
		[Kinds!TKind!Array] = null,
		[Endpoint] = lower(a2meta.fn_Schema2Text(t.[Schema]) + '/' + t.[Name])
	from a2meta.[Catalog] t 
		left join a2meta.[Catalog] p on t.ParentTable = p.Id
		left join a2meta.[Catalog] x on t.Parent = x.Id and x.Kind <> N'folder'
	where t.Id = @Id;
	
	select [!TColumn!Array] = null, [Id!!Id] = c.Id, [Name!!Name] = c.[Name], c.[Label],
		c.DataType, c.[MaxLength], c.[Role], c.Source, c.Computed, c.[Required], c.[Total], c.[Unique],
		[Reference.Id!TRef!Id] = c.Reference, [Reference.Name!TRef!Name] = a2meta.fn_TableFullName(rt.[Schema], rt.[Name]),
		[Order!!RowNumber] = c.[Order],
		[!TTable.Columns!ParentId] = @Id
	from a2meta.Columns c 
		left join a2meta.[Catalog] rt on c.Reference = rt.Id 
	where c.[Table] = @Id
	order by c.[Order];

	select [!TKind!Array] = null, [Id!!Id] = Id, [Name], [Label],
		[Order!!RowNumber] = [Order],
		[!TTable.Kinds!ParentId] = Details
	from a2meta.[DetailsKinds]
	where [Details] = @Id
	order by [Order];

	select [!TApply!Array] = null, [Id!!Id] = a.Id, a.[InOut], a.Storno,
		[RowNo!!RowNumber] = a.[Order], 
		[Kind.Id!TKind!Id] = a.[Kind], [Kind.Name!TKind!Name] = dk.[Name],
		[Journal.Id!TRef!Id] = a.Journal, [Journal.Name!TRef!Name] = a2meta.fn_TableFullName(j.[Schema], j.[Name]),
		[Details.Id!TRef!Id] = a.Details, [Details.Name!TRef!Name] = a2meta.fn_TableFullName(d.[Schema], d.[Name]),
		[!TTable.Apply!ParentId] = @Id
	from a2meta.[Apply] a
		left join a2meta.[Catalog] j on a.Journal = j.Id
		left join a2meta.[Catalog] d on a.Details = d.Id
		left join a2meta.DetailsKinds dk on a.Kind = dk.Id
	where a.[Table] = @Id
	order by a.[Order];
end
go
------------------------------------------------
drop procedure if exists a2meta.[Table.Metadata];
drop procedure if exists a2meta.[Table.Update];
drop procedure if exists a2meta.[Report.Metadata];
drop procedure if exists a2meta.[Report.Update];
drop procedure if exists a2meta.[Enum.Metadata];
drop procedure if exists a2meta.[Enum.Update];
drop procedure if exists a2meta.[Application.Metadata];
drop procedure if exists a2meta.[Application.Update];
drop type if exists a2meta.[App.TableType];
drop type if exists a2meta.[Table.TableType];
drop type if exists a2meta.[Table.Column.TableType];
drop type if exists a2meta.[Table.Kind.TableType];
drop type if exists a2meta.[Table.Apply.TableType];
drop type if exists a2meta.[Table.RepItem.TableType];
drop type if exists a2meta.[Table.EnumItem.TableType];
go
------------------------------------------------
create type a2meta.[App.TableType] as table (
	[Id] uniqueidentifier,
	[Name] nvarchar(255),
	[Title] nvarchar(255),
	IdDataType nvarchar(32),
	Memo nvarchar(255)
);
go
------------------------------------------------
create type a2meta.[Table.TableType] as table (
	Id uniqueidentifier,
	[Name] nvarchar(128),
	[ItemsName] nvarchar(128),
	[ItemName] nvarchar(128),
	[TypeName] nvarchar(128),
	EditWith nvarchar(16),
	ParentTable uniqueidentifier,
	ItemLabel nvarchar(255),
	ItemsLabel nvarchar(255),
	UseFolders bit,
	FolderMode nvarchar(16),
	[Type] nvarchar(32)
);
go
------------------------------------------------
create type a2meta.[Table.Column.TableType] as table (
	Id uniqueidentifier,
	[Name] nvarchar(128),
	[Label] nvarchar(255),
	[DataType] nvarchar(32),
	[MaxLength] int,
	[Modifier] nvarchar(32),
	[Role] bigint,
	Reference uniqueidentifier,
	[Order] int,
	[Computed] nvarchar(255),
	[Required] bit,
	[Total] bit,
	[Unique] bit
);
go
------------------------------------------------
create type a2meta.[Table.RepItem.TableType] as table (
	Id uniqueidentifier,
	[Label] nvarchar(255),
	[Column] uniqueidentifier,
	[Order] int,
	[Func] nvarchar(32),
	[Checked] bit
);
go
------------------------------------------------
create type a2meta.[Table.EnumItem.TableType] as table (
	Id uniqueidentifier,
	[Name] nvarchar(16) not null,
	[Label] nvarchar(255),
	[Order] int not null,
	[Inactive] bit
);
go
------------------------------------------------
create type a2meta.[Table.Kind.TableType] as table (
	[Id] uniqueidentifier null,
	[Order] int null,
	[Name] nvarchar(32),
	[Label] nvarchar(255)
);
go
------------------------------------------------
create type a2meta.[Table.Apply.TableType] as table (
	[Id] uniqueidentifier,
	[Journal] uniqueidentifier,
	[RowNo] int null,
	Details uniqueidentifier,
	[InOut] smallint,
	Storno bit,
	Kind uniqueidentifier
);
go
------------------------------------------------
create or alter procedure a2meta.[Table.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @Table a2meta.[Table.TableType];
	declare @Columns a2meta.[Table.Column.TableType];
	declare @Apply a2meta.[Table.Apply.TableType];
	declare @Kinds a2meta.[Table.Kind.TableType];

	select [Table!Table!Metadata] = null, * from @Table;
	select [Columns!Table.Columns!Metadata] = null, * from @Columns;
	select [Apply!Table.Apply!Metadata] = null, * from @Apply;
	select [Kinds!Table.Kinds!Metadata] = null, * from @Kinds;
end
go
------------------------------------------------
create or alter procedure a2meta.[Table.Update]
@UserId bigint,
@Table a2meta.[Table.TableType] readonly,
@Columns a2meta.[Table.Column.TableType] readonly,
@Apply a2meta.[Table.Apply.TableType] readonly,
@Kinds a2meta.[Table.Kind.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read committed;

	declare @Id uniqueidentifier;
	select @Id = Id from @Table;

	merge a2meta.[Catalog] as t
	using @Table as s on
	t.Id = s.Id
	when matched then update set
		t.[Name] = s.[Name],
		t.[ItemsName] = s.[ItemsName],
		t.[ItemName] = s.[ItemName],
		t.[TypeName] = s.[TypeName],
		t.EditWith = s.EditWith,
		t.ParentTable = s.ParentTable,
		t.ItemLabel = s.ItemLabel,
		t.ItemsLabel = s.ItemsLabel,
		t.UseFolders = s.UseFolders,
		t.FolderMode = s.FolderMode,
		t.[Type] = s.[Type];

	merge a2meta.[Columns] as t
	using @Columns as s
	on t.Id = s.Id
	when matched then update set
		t.[Name] = s.[Name],
		t.[Label] = s.[Label],
		t.DataType = s.[DataType],
		t.[MaxLength] = s.[MaxLength],
		t.Reference = s.Reference,
		t.[Role] = s.[Role],
		t.[Order] = s.[Order],
		t.Computed = s.Computed,
		t.[Required] = s.[Required],
		t.[Total] = s.[Total],
		t.[Unique] = s.[Unique]
	when not matched then insert
		([Table], [Name], [Label], DataType, [MaxLength], Reference, [Role], [Order], 
			Computed, [Required], [Total], [Unique]) values
		(@Id, s.[Name], s.[Label], s.[DataType], s.[MaxLength], s.Reference, s.[Role], s.[Order], 
			s.Computed, s.[Required], s.[Total], s.[Unique])
	when not matched by source and t.[Table] = @Id then delete;

	merge a2meta.[Apply] as t
	using @Apply as s
	on t.Id = s.Id
	when matched then update set
		t.Journal = s.Journal,
		t.Details = s.Details,
		t.InOut = s.InOut,
		t.Storno = s.Storno,
		t.[Order] = s.RowNo,
		t.Kind = s.Kind
	when not matched then insert
		([Table], Journal, Details, InOut, [Order], Storno, Kind) values
		(@Id, s.Journal, s.Details, s.InOut, s.RowNo, s.Storno, s.Kind)
	when not matched by source and t.[Table] = @Id then delete;

	merge a2meta.[DetailsKinds] as t
	using @Kinds as s
	on t.Id = s.Id
	when matched then update set
		t.[Name] = s.[Name],
		t.[Label] = s.[Label],
		t.[Order] = s.[Order]
	when not matched then insert
		([Details], [Name], [Label], [Order]) values
		(@Id, s.[Name], s.[Label], s.[Order])
	when not matched by source and t.[Details] = @Id then delete;

	exec a2meta.[Table.Load] @UserId, @Id;
end
go
------------------------------------------------
create or alter procedure a2meta.[Report.Load]
@UserId bigint,
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Table!TTable!Object] = null, [Id!!Id] = t.Id, [Name!!Name] = t.[Name], t.[Schema], t.Kind,
		t.ItemsName, t.ItemName, t.Source, t.ItemsLabel, t.ItemLabel, t.[Type],
		[ParentTable.Id!TPTable!Id] = t.ParentTable, [ParentTable.Name!TPTable!Name] = a2meta.fn_TableFullName(p.[Schema], p.[Name]),
		[ParentTable.Endpoint!TPTable!] = lower(a2meta.fn_Schema2Text(p.[Schema]) + '/' + p.[Name]),
		[Endpoint] = lower(a2meta.fn_Schema2Text(t.[Schema]) + '/' + t.[Name]),
		[Filters!TRepItem!Array] = null,
		[Grouping!TRepItem!Array] = null,
		[Data!TRepItem!Array] = null
	from a2meta.[Catalog] t 
		left join a2meta.[Catalog] p on t.ParentTable = p.Id
	where t.Id = @Id;

	select [!TRepItem!Array] = null, [Id!!Id] = ri.Id, ri.Checked, ri.Func, ri.[Label],
		[Column.Id!TColumn!Id] = c.Id, [Column.Name!TColumn!Name] = t.[Name] + N'.' + c.[Name],
		[Column.Field!TColumn!] = c.[Name], [Column.DataType!TColumn!] = c.[DataType],
		[Order!!RowNumber] = ri.[Order],
		[!TTable.Filters!ParentId] = case when ri.Kind = N'F' then ri.Report else null end,
		[!TTable.Grouping!ParentId] = case when ri.Kind = N'G' then ri.Report else null end,
		[!TTable.Data!ParentId] = case when ri.Kind = N'D' then ri.Report else null end
	from a2meta.ReportItems ri
		inner join a2meta.Columns c on ri.[Column] = c.Id
		inner join a2meta.[Catalog] t on c.[Table] = t.Id
	where ri.Report = @Id
	order by ri.[Order];
end
go
------------------------------------------------
create or alter procedure a2meta.[Report.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @Table a2meta.[Table.TableType];
	declare @RepItem a2meta.[Table.RepItem.TableType];

	select [Table!Table!Metadata] = null, * from @Table;
	select [Grouping!Table.Grouping!Metadata] = null, * from @RepItem;
	select [Filters!Table.Filters!Metadata] = null, * from @RepItem;
	select [Data!Table.Data!Metadata] = null, * from @RepItem;
end
go
------------------------------------------------
create or alter procedure a2meta.[Report.Update]
@UserId bigint,
@Table a2meta.[Table.TableType] readonly,
@Grouping a2meta.[Table.RepItem.TableType] readonly,
@Filters a2meta.[Table.RepItem.TableType] readonly,
@Data a2meta.[Table.RepItem.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read committed;

	declare @Id uniqueidentifier;
	select @Id = Id from @Table;

	merge a2meta.[Catalog] as t
	using @Table as s on
	t.Id = s.Id
	when matched then update set
		t.[Name] = s.[Name],
		t.ParentTable = s.ParentTable,
		t.ItemLabel = s.ItemLabel,
		t.[Type] = s.[Type];

	with TI as (
		select Kind = 'F', * from @Filters
		union all
		select Kind = 'G', * from @Grouping
		union all
		select Kind = 'D', * from @Data		
	)
	merge a2meta.ReportItems as t
	using TI as s
	on t.Id = s.Id and t.Report = @Id
	when matched then update set
		t.[Label] = s.[Label],
		t.Checked = s.Checked,
		t.[Order] = s.[Order],
		t.Func = s.Func
	when not matched then insert
		 (Report, [Column], Kind, [Order], [Label], Func, Checked) values
		 (@Id, s.[Column], s.Kind, s.[Order], s.[Label], s.Func, s.Checked)
	when not matched by source and t.Report = @Id then delete;

	exec a2meta.[Report.Load] @UserId, @Id;
end
go
------------------------------------------------
create or alter procedure a2meta.[Enum.Load]
@UserId bigint,
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Table!TTable!Object] = null, [Id!!Id] = t.Id, [Name!!Name] = t.[Name], t.[Schema], t.Kind,
		t.ItemsName, t.ItemName, t.Source, t.ItemsLabel, t.ItemLabel, t.[Type],
		[Items!TEnumItem!Array] = null
	from a2meta.[Catalog] t 
		left join a2meta.[Catalog] p on t.ParentTable = p.Id
	where t.Id = @Id;

	select [!TEnumItem!Array] = null, [Id!!Id] = ei.Id, ei.[Name], ei.[Label], 
		[Order!!RowNumber] = ei.[Order],
		[!TTable.Items!ParentId] = ei.Enum
	from a2meta.EnumItems ei
	where ei.Enum = @Id
	order by ei.[Order];
end
go

------------------------------------------------
create or alter procedure a2meta.[Enum.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @Table a2meta.[Table.TableType];
	declare @EnumItem a2meta.[Table.EnumItem.TableType];

	select [Table!Table!Metadata] = null, * from @Table;
	select [Items!Table.Items!Metadata] = null, * from @EnumItem;
end
go
------------------------------------------------
create or alter procedure a2meta.[Enum.Update]
@UserId bigint,
@Table a2meta.[Table.TableType] readonly,
@Items a2meta.[Table.EnumItem.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read committed;

	declare @Id uniqueidentifier;
	select @Id = Id from @Table;

	merge a2meta.[Catalog] as t
	using @Table as s on
	t.Id = s.Id
	when matched then update set
		t.[Name] = s.[Name];

	merge a2meta.EnumItems as t
	using @Items as s
	on t.Id = s.Id and t.Enum = @Id
	when matched then update set
		t.[Name] = s.[Name],
		t.[Label] = s.[Label],
		t.[Order] = s.[Order],
		t.Inactive = s.Inactive
	when not matched then insert
		 (Enum, [Name], [Label], [Order], Inactive) values
		 (@Id, s.[Name], s.[Label], s.[Order], s.Inactive)
	when not matched by source and t.Enum = @Id then delete;

	exec a2meta.[Enum.Load] @UserId, @Id;
end
go
------------------------------------------------
create or alter procedure a2meta.[Application.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	declare @App a2meta.[App.TableType];

	select [App!App!Metadata] = null, * from @App;
end
go
------------------------------------------------
create or alter procedure a2meta.[Application.Update]
@UserId bigint,
@App a2meta.[App.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read committed;

	declare @Id uniqueidentifier;
	select @Id = Id from @App;

	update a2meta.[Application] set [Name] = s.[Name], [Title] = s.Title,
		IdDataType = s.IdDataType, Memo = s.[Memo]
	from a2meta.[Application] t inner join @App s on  t.Id = s.Id

	exec a2meta.[Application.Load] @UserId, @Id;
end
go
------------------------------------------------
create or alter procedure a2meta.[Reference.Index]
@UserId bigint,
@Id uniqueidentifier = null,
@Fragment nvarchar(255) = null,
@Schema nvarchar(32) = null,
@DataType nvarchar(32) = null
as
begin
	set nocount on;
	set transaction isolation level read committed;

	declare @fr nvarchar(255) = N'%' + @Fragment + N'%';

	select [Tables!TRefTable!Array] = null, [Id!!Id] = Id, [Name!!Name] = a2meta.fn_TableFullName([Schema], [Name]),
		[Schema] = a2meta.fn_Schema2Text([Schema]), TableName = [Name]
	from a2meta.[Catalog] where 
		(@DataType = N'reference' and Kind in (N'table', N'details')
			or @DataType = N'enum' and Kind in (N'enum'))
		and (@Schema is null or [Schema] = @Schema)
		and (@fr is null or [Name] like @fr)
	order by [Name];		
end
go
------------------------------------------------
create or alter procedure a2meta.[Reference.Fetch]
@UserId bigint,
@Text nvarchar(255),
@Schema nvarchar(32) = null,
@DataType nvarchar(32) = null
as
begin
	set nocount on;
	set transaction isolation level read committed;

	declare @fr nvarchar(255) = N'%' + @Text + N'%';

	select [Tables!TRefTable!Array] = null, [Id!!Id] = Id, [Name!!Name] = a2meta.fn_TableFullName([Schema], [Name])
	from a2meta.[Catalog] where 
		(@DataType = N'reference' and Kind in (N'table', N'details')
			or @DataType = N'enum' and Kind in (N'enum'))
		and [Name] like @fr
		and (@Schema is null or [Schema] = @Schema)
	order by [Name];		
end
go
------------------------------------------------
create or alter procedure a2meta.[Details.Index] 
@UserId bigint,
@Id uniqueidentifier = null,
@Text nvarchar(255) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @fr nvarchar(255) = N'%' + @Text + N'%';

	select [Tables!TRefTable!Array] = null, [Id!!Id] = Id, [Name!!Name] = a2meta.fn_TableFullName([Schema], [Name])
	from a2meta.[Catalog] where Kind in (N'details') 
		and (@fr is null or [Name] like @fr)
	order by [Name];		
end
go

------------------------------------------------
create or alter procedure a2meta.[DetailsKind.Index] 
@UserId bigint,
@Id uniqueidentifier = null,
@Details uniqueidentifier,
@Text nvarchar(255) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @fr nvarchar(255) = N'%' + @Text + N'%';

	select [Kinds!TKind!Array] = null, [Id!!Id] = Id, [Name!!Name] = [Name]
	from a2meta.DetailsKinds where Details = @Details
		and (@fr is null or [Name] like @fr)
	order by [Order];
end
go
------------------------------------------------
create or alter procedure a2meta.[Deploy.Index]
@UserId bigint,
@Id uniqueidentifier = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @count int;
	select @count = count(*) from a2meta.[Catalog]
	where IsFolder = 0 and [Kind] in (N'table', N'details');

	declare @tmp table([Name] nvarchar(255), [Kind] nvarchar(32));
	insert into @tmp ([Kind], [Name]) values
	(N'Table', N'Tables'),
	(N'TableType', N'Table Types'),
	(N'ForeignKey', N'Foreign Keys');

	select [Deploy!TDeploy!Array] = null, [Name], Kind, [Count] = @count,
		[TableName] = cast(null as nvarchar(255)), [Index] = 0,
		[Table] = cast(null as nvarchar(255))
	from @tmp
end
go
------------------------------------------------
create or alter procedure a2meta.[Apply.Mapping.Auto]
@Id uniqueidentifier,
@Table uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read committed;

	declare @jrnTable uniqueidentifier, @detailsTable uniqueidentifier;

	select @jrnTable = Journal, @detailsTable = Details 
	from a2meta.Apply
	where Id = @Id;

	declare @maps table(TargetId uniqueidentifier, TargetName nvarchar(255), TargetRef uniqueidentifier,
		[SourceId] uniqueidentifier, SourceName nvarchar(255), [Order] int);

	insert into @maps(TargetId, TargetName, [Order], TargetRef)
	select Id, [Name], [Order], Reference from a2meta.Columns 
	where [Table] = @jrnTable and [Name] not in (N'Id', 'InOut');

	declare @TablePK uniqueidentifier
	select @TablePK = Id from a2meta.Columns c
	where c.[Table] = @Table and [Role] = 1;

	update @maps set SourceId = @TablePK
	where TargetRef = @Table;

	-- base table first
	update @maps set SourceId = c.Id
	--select c.Id, * 
	from @maps m inner join a2meta.Columns c on m.[TargetName] = c.[Name] -- and MatchType(c.DataType)
	where c.[Table] = @Table;

	if @detailsTable is not null
		update @maps set SourceId = c.Id
		--select c.Id, * 
		from @maps m inner join a2meta.Columns c on m.[TargetName] = c.[Name] -- and MatchType(c.DataType)
		where c.[Table] = @detailsTable;

	insert into a2meta.ApplyMapping (Apply, [Target], Source)
	select Apply = @Id, [Target] = TargetId, [Source] = SourceId
		--[RowNo] = row_number() over (order by [Order])
	from @maps where SourceId is not null
	order by [Order];
end
go
------------------------------------------------
create or alter procedure a2meta.[Mapping.Load]
@UserId bigint,
@Id uniqueidentifier = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @opTable uniqueidentifier;
	select @opTable = c.ParentTable
	from a2meta.[Apply] a inner join a2meta.[Catalog] c on a.[Table] = c.Id
	where a.Id = @Id;

	if not exists(select * from a2meta.ApplyMapping where Apply = @Id)
		exec a2meta.[Apply.Mapping.Auto] @Id, @opTable;

	select [Apply!TApply!Object] = null, [Id!!Id] = @Id;

	select [Mapping!TMapping!Array] = null, [Id!!Id] = a.Id,
		[Target.Id!TColumn!Id] = a.[Target], [Target.Name!TColumn!Name] = ct.[Name], [Target.DataType!TColumn!] = ct.DataType,
		[Source.Id!TColumn!Id] = a.[Source], [Source.Name!TColumn!Name] = cs.[Name], [Source.DataType!TColumn!] = cs.DataType,
		[TargetTable!TTable!RefId] = ct.[Table],
		[SourceTable!TTable!RefId] = cs.[Table]
	from a2meta.ApplyMapping a
		inner join a2meta.Columns cs on a.Source = cs.Id
		inner join a2meta.Columns ct on a.[Target] = ct.Id
	where Apply = @Id
	order by a.[Id];

	select [Tables!TTable!Map] = null, [Id!!Id] = c.Id, 
		[Name] = a2meta.fn_TableFullName(c.[Schema], c.[Name]),		
		IsJournal = cast(case when c.[Schema] = N'jrn' then 1 else 0 end as bit),
		[Columns!TColumn!Array] = null
	from a2meta.[Catalog] c
		inner join a2meta.Apply a on c.Id in (a.Details, a.Journal, @opTable)
	where a.Id = @Id;

	select [!TColumn!Array] = null, [Id!!Id] = c.Id, [Name!!Name] = c.[Name], c.DataType,
		[!TTable.Columns!ParentId] = c.[Table]
	from a2meta.Columns c
		inner join a2meta.Apply a on c.[Table] in (a.Details, a.Journal, @opTable)
	where a.Id = @Id
	order by c.Id;
end
go
------------------------------------------------
drop procedure if exists a2meta.[Mapping.Metadata];
drop procedure if exists a2meta.[Mapping.Update];
drop type if exists a2meta.[Mapping.TableType];
go
------------------------------------------------
create type a2meta.[Mapping.TableType] as table (
	Id uniqueidentifier,
	Source uniqueidentifier,
	[Target] uniqueidentifier
);
go
------------------------------------------------
create or alter procedure a2meta.[Mapping.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	declare @Mapping a2meta.[Mapping.TableType];
	select [Mapping!Mapping!Metadata] = null, * from @Mapping;
end
go
------------------------------------------------
create or alter procedure a2meta.[Mapping.Update]
@UserId bigint,
@Id nvarchar(255), -- PLATFORM FEATURE
@Mapping a2meta.[Mapping.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @ApplyId uniqueidentifier;
	set @ApplyId = cast(@Id as uniqueidentifier);

	merge a2meta.ApplyMapping as t
	using @Mapping as s
	on t.Id = s.Id and t.Apply = @ApplyId
	when matched then update set
		t.[Source] = s.Source,
		t.[Target] = s.[Target]
	when not matched then insert
		(Apply, [Target], Source) values
		(@Id, s.[Target], s.Source)
	when not matched by source and t.Apply = @Id then delete;

	exec a2meta.[Mapping.Load] @UserId = @UserId, @Id = @ApplyId;
end
go

------------------------------------------------
create or alter procedure a2meta.[Interface.Load]
@UserId bigint,
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Interface!TInterface!Object] = null, [Id!!Id] = t.Id, [Name!!Name] = t.[Name], 
		t.[Schema],
		t.Kind, t.ItemsName, t.ItemName, t.Source, t.TypeName,
		[Sections!TSection!Array] = null
	from a2meta.[Catalog] t 
		left join a2meta.[Catalog] p on t.ParentTable = p.Id
	where t.Id = @Id;

	select [!TSection!Array] = null, [Id!!Id] = Id, [Name], [Url],
		[Order!!RowNumber] = [Order],
		[MenuItems!TMenuItem!Array] = null,
		[!TInterface.Sections!ParentId] = Interface
	from a2meta.MenuItems where [Interface] = @Id and Parent is null
	order by [Order];

	select [!TMenuItem!Array] = null, [Id!!Id] = Id, [Name], [Url],
		[Order!!RowNumber] = [Order],
		[!TSection.MenuItems!ParentId] = Parent
	from a2meta.MenuItems where [Interface] = @Id and Parent is not null
	order by [Order];
end
go


------------------------------------------------
drop procedure if exists a2meta.[Interface.Metadata];
drop procedure if exists a2meta.[Interface.Update];
drop type if exists a2meta.[Interface.TableType];
drop type if exists a2meta.[Interface.Section.TableType];
go
------------------------------------------------
create type a2meta.[Interface.TableType] as table (
	Id uniqueidentifier,
	[Name] nvarchar(255),
	ItemName nvarchar(255) -- icon
);
go
------------------------------------------------
create type a2meta.[Interface.Section.TableType] as table (
	[GUID] uniqueidentifier,
	[ParentGUID] uniqueidentifier,
	Id uniqueidentifier,
	[Name] nvarchar(255),
	[Url] nvarchar(255),
	[Order] int
);
go
------------------------------------------------
create or alter procedure a2meta.[Interface.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	declare @Interface a2meta.[Interface.TableType];
	declare @Sections a2meta.[Interface.Section.TableType];
	select [Interface!Interface!Metadata] = null, * from @Interface;
	select [Sections!Interface.Sections!Metadata] = null, * from @Sections;
	select [MenuItems!Interface.Sections.MenuItems!Metadata] = null, * from @Sections;
end
go
------------------------------------------------
create or alter function a2meta.LocalizeName(@Name nvarchar(255))
returns nvarchar(255)
as
begin
	if @Name is null or len(@Name) < 1
		return @Name;
	if N'@' = substring(@Name, 1, 1) 
		return N'@[' + substring(@Name, 2, 255) + N']';
	return @Name;
end
go
------------------------------------------------
create or alter procedure a2meta.[Interface.Deploy] 
@UserId bigint, 
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read committed;

	declare @emptyGuid uniqueidentifier = cast(N'00000000-0000-0000-0000-000000000000' as uniqueidentifier);

	with TR as (
		select [Id], [Name] = a2meta.LocalizeName([Name]), Icon = ItemName, [Order] 
		from a2meta.[Catalog] where Id = @Id
	)
	merge a2ui.Menu as t
	using TR as s
	on t.Id = s.Id
	when matched then update set
		t.[Name] = s.[Name],
		t.[Icon] = s.[Icon],
		t.[Order] = s.[Order]
	when not matched then insert
		(Id, Parent, [Name], [Icon], [Order]) values
		(@Id, @emptyGuid, s.[Name], s.[Icon], s.[Order]);		
	
	with TF as (
		select Id, Interface, Parent, [Name] = a2meta.LocalizeName([Name]), [Url], [Order]
		from a2meta.MenuItems where Interface = @Id
	)
	merge a2ui.Menu as t
	using TF as s
	on t.Id = s.Id
	when matched then update set 
		t.[Name] = s.[Name],
		t.[Order] = s.[Order],
		t.[Url] =  N'page:/' + s.[Url] + N'/index/0'
	when not matched then insert 
		(Id, Parent, [Name], [Order], 
			[Url]) values
		(s.Id, isnull(s.Parent, @Id), s.[Name], s.[Order],
			N'page:/' + s.[Url] + N'/index/0');
end
go
------------------------------------------------
create or alter procedure a2meta.[Interface.Update]
@UserId bigint,
@Interface a2meta.[Interface.TableType] readonly,
@Sections a2meta.[Interface.Section.TableType] readonly,
@MenuItems a2meta.[Interface.Section.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read committed;

	declare @Id uniqueidentifier;
	select @Id = Id from @Interface;

	merge a2meta.[Catalog] as t
	using @Interface as s on t.Id = s.Id
	when matched then update set
		t.[Name] = s.[Name],
		t.ItemName = s.[ItemName];

	declare @rmenu table(Id uniqueidentifier, [GUID] uniqueidentifier);

	merge a2meta.[MenuItems] as t
	using @Sections as s
	on t.Id = s.Id and t.Interface = @Id and t.Parent is null
	when matched then update set
		t.[Name] = s.[Name],
		t.[Order] = s.[Order]
	when not matched then insert
		(Interface, Parent, [Name], [Order]) values
		(@Id, null, s.[Name], s.[Order])
	when not matched by source and t.Interface = @Id and t.Parent is null then delete
	output inserted.Id, s.[GUID] into @rmenu(Id, [GUID]);

	with TT as (
		select * from a2meta.MenuItems where Interface = @Id and Parent is not null
	),
	TS as (
		select mi.Id, Parent = rm.Id, mi.[Name], mi.[Url], mi.[Order]
		from @MenuItems mi
		inner join @rmenu rm on mi.ParentGUID = rm.[GUID]
	)
	merge TT as t
	using TS as s
	on t.Id = s.Id and t.Interface = @Id
	when matched then update set
		t.[Name] = s.[Name],
		t.[Url] = s.[Url],
		t.[Order] = s.[Order]
	when not matched then insert
		(Interface, Parent, [Name], [Url], [Order]) values
		(@Id, s.Parent, s.[Name], s.[Url], s.[Order])
	when not matched by source and t.Interface = @Id and t.Parent is not null then delete;

	exec a2meta.[Interface.Deploy] @UserId, @Id;

	exec a2meta.[Interface.Load] @UserId, @Id;
end
go
------------------------------------------------
create or alter procedure a2meta.[Journal.Field.Index] 
@UserId bigint,
@Id uniqueidentifier = null,
@Journal uniqueidentifier,
@Kind nchar(1)
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Columns!TColumn!Array] = null, [Id!!Id] = c.Id, Field = c.[Name], c.[DataType],
		[Name] = t.[Name] + N'.' + c.[Name]
	from a2meta.[Columns] c
	inner join a2meta.[Catalog] t on c.[Table] = t.Id
	where [Table] = @Journal and c.[Name] not in (N'Id', N'InOut')
	order by c.[Order];
end
go

------------------------------------------------
create or alter procedure a2meta.[Endpoint.Index] 
@UserId bigint,
@Id uniqueidentifier = null,
@Fragment nvarchar(255) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @fr nvarchar(255) = N'%' + @Fragment + N'%';

	select [Endpoints!TEndpoint!Array] = null, [Schema] = a2meta.fn_Schema2Text(t.[Schema]),
		[Name] = isnull(isnull(ItemsLabel, ItemLabel), isnull(N'@' + ItemsName, N'@' + [Name])), [Endpoint] = lower(a2meta.fn_Schema2Text(t.[Schema]) + '/' + t.[Name])
	from a2meta.[Catalog] t
	where t.IsFolder = 0 and Kind in (N'table', N'operation', N'report')
		and (@fr is null or t.[Name] like @fr or t.ItemsName like @fr or t.ItemsLabel like @fr)
	order by [Schema];
end
go
------------------------------------------------
create or alter procedure a2meta.[Config.ResetForm] 
@UserId bigint,
@Id uniqueidentifier,
@Key nvarchar(32)
as
begin
	set nocount on;
	set transaction isolation level read committed;

	delete from a2meta.Forms where [Table] = @Id and [Key] = @Key;
end
go

select * from a2meta.Forms

