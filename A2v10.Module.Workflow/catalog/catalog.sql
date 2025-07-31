-- CATALOG
------------------------------------------------
create or alter procedure wfadm.[Catalog.Index]
@UserId bigint,
@Id nvarchar(64) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @wftable table(Id nvarchar(255), [Version] int);
	insert into @wftable(Id, [Version])
	select [Id], [Version] = max([Version])
	from a2wf.Workflows
	group by Id;

	select [Workflows!TWorkflow!Array] = null, [Id!!Id] = w.Id, w.[Name], t.[Version],
		[DateCreated!!Utc] = w.DateCreated, [DateModified!!Utc] = w.DateModified,
		w.Svg, w.Zoom, w.Memo, w.[Key],
		NeedPublish = cast(case when w.[Hash] = x.[Hash] then 0 else 1 end as bit)
	from a2wf.[Catalog] w left join @wftable t on w.Id = t.Id
		left join a2wf.Workflows x on w.Id = x.Id and x.[Version] = t.[Version]
	order by w.DateCreated desc;
end
go
------------------------------------------------
create or alter procedure wfadm.[Catalog.Load]
@UserId bigint,
@Id nvarchar(64) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	set @Id = upper(@Id);

	declare @version int, @hash varbinary(64);
	select @version = max([Version]) from a2wf.Workflows where Id = @Id;
	select @hash = [Hash] from a2wf.Workflows where Id = @Id and [Version] = @version;

	select [Workflow!TWorkflow!Object] = null, [Id!!Id] = Id, [Name!!Name] = [Name], [Body],
		[Svg] = cast(null as nvarchar(max)), [Version] = @version,  Zoom,
		[DateCreated!!Utc] = DateCreated, [DateModified!!Utc] = DateModified,
		NeedPublish = cast(case when [Hash] = @hash then 0 else 1 end as bit),
		[Key], [Memo]
	from a2wf.[Catalog] 
	where Id = @Id collate SQL_Latin1_General_CP1_CI_AI
	order by Id;
end
go
------------------------------------------------
drop procedure if exists wfadm.[Catalog.Metadata];
drop procedure if exists wfadm.[Catalog.Update];
drop type if exists wfadm.[Catalog.TableType];
go
------------------------------------------------
create type wfadm.[Catalog.TableType] as table
(
	Id nvarchar(64),
	[Name] nvarchar(255),
	[Body] nvarchar(max),
	Svg nvarchar(max),
	Zoom float
);
go
------------------------------------------------
create or alter procedure wfadm.[Catalog.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	declare @Workflow wfadm.[Catalog.TableType];
	select [Workflow!Workflow!Metadata] = null, * from @Workflow;
end
go
------------------------------------------------
create or alter procedure wfadm.[Catalog.Update]
@UserId bigint,
@Workflow wfadm.[Catalog.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;

	declare @rtable table(Id nvarchar(64));
	declare @wfid nvarchar(64);

	merge a2wf.[Catalog] as t
	using @Workflow as s
	on t.Id = s.Id collate SQL_Latin1_General_CP1_CI_AI
	when matched then update set
		t.[Name] = s.[Name],
		t.[Body] = s.[Body],
		t.Svg = s.Svg,
		t.Zoom = round(s.Zoom, 2),
		t.[Hash] = hashbytes(N'SHA2_256', s.Body),
		t.DateModified = getutcdate()
	when not matched then insert 
		(Id, 
			[Name], [Body], Svg, Zoom, [Format], [Hash]) values
		(upper(cast(newid() as nvarchar(64))), 
			s.[Name], s.[Body], s.Svg, round(s.Zoom, 2), N'text/xml', hashbytes(N'SHA2_256', s.Body))
 	output inserted.Id into @rtable(Id);
	select @wfid = Id from @rtable;

	exec wfadm.[Catalog.Load] @UserId = @UserId, @Id = @wfid;
end
go

------------------------------------------------
create or alter procedure wfadm.[Workflow.Fetch]
@UserId bigint,
@Text nvarchar(255)
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	
	declare @fr nvarchar(255) = N'%' + @Text + N'%';
	select [Workflows!TWorkflow!Array] = null, [Id!!Id] = c.Id, [Name!!Name] = c.[Name]
	from a2wf.[Catalog] c
	where (@fr is null or c.[Name] like @fr)
		and c.Id in (select Id from a2wf.Workflows);
end
go
------------------------------------------------
create or alter procedure wfadm.[Workflow.Download.Load]
@UserId bigint,
@Id uniqueidentifier,
@Key nvarchar(64) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Name] = [Name] + N'.bpmn', Mime =  [Format], 
		[Data] = Body, SkipToken = cast(1 as bit)
	from a2wf.[Catalog] where Id = @Id;
end
go
------------------------------------------------
create or alter procedure wfadm.[Workflow.Upload.Update] 
@UserId bigint,
@Id uniqueidentifier = null,
@Stream varbinary(max),
@Name nvarchar(255),
@Mime nvarchar(255)
as
begin
	set nocount on;
	set transaction isolation level read committed;

	-- convert varbinary to nvarchar (UTF8)
	if right(@Name, 5) <> N'.bpmn'
		throw 60000, N'UI:Only *.bpmn files are supported', 0;

	declare @tmp table(val varchar(max) collate LATIN1_GENERAL_100_CI_AS_SC_UTF8);
	insert into @tmp(val) values (@Stream);

	declare @xml nvarchar(max);
	select @xml = val from @tmp;

	declare @wfid uniqueidentifier = newid();
	declare @idstr nvarchar(255) = upper(cast(@wfid as nvarchar(255)));

	insert into a2wf.[Catalog](Id, [Name], [Body], [Format], [Hash]) values
		(@idstr, replace(@Name, N'.bpmn', N''), 
		@xml, N'text/xml', hashbytes(N'SHA2_256', @xml));

	select [Result!TResult!Object] = null, [Id] = @idstr;
end
go
------------------------------------------------
create or alter procedure wfadm.[Workflow.Delete]
@UserId bigint,
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;

	if exists(select * from a2wf.Workflows where Id = @Id)
		throw 60000, N'UI:@[WfAdm.Error.WorkflowUsed]', 0;
	delete from a2wf.[Catalog] where Id = @Id;
end
go

------------------------------------------------
create or alter procedure wfadm.[Catalog.Prop.Load]
@UserId bigint,
@Id nvarchar(64) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	set @Id = upper(@Id);

	select [Workflow!TWorkflow!Object] = null, [Id!!Id] = Id, [Name!!Name] = [Name],
		Memo, [Key]
	from a2wf.[Catalog] 
	where Id = @Id collate SQL_Latin1_General_CP1_CI_AI
	order by Id;
end
go
------------------------------------------------
drop procedure if exists wfadm.[Catalog.Prop.Metadata];
drop procedure if exists wfadm.[Catalog.Prop.Update];
drop type if exists wfadm.[Catalog.Prop.TableType];
go
------------------------------------------------
create type wfadm.[Catalog.Prop.TableType] as table
(
	Id nvarchar(64),
	[Name] nvarchar(255),
	[Key] nvarchar(32),
	[Memo] nvarchar(255)
);
go
------------------------------------------------
create or alter procedure wfadm.[Catalog.Prop.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	declare @Workflow wfadm.[Catalog.Prop.TableType];
	select [Workflow!Workflow!Metadata] = null, * from @Workflow;
end
go
------------------------------------------------
create or alter procedure wfadm.[Catalog.Prop.Update]
@UserId bigint,
@Workflow wfadm.[Catalog.Prop.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;

	declare @rtable table(Id nvarchar(64));
	declare @wfid nvarchar(64);

	merge a2wf.[Catalog] as t
	using @Workflow as s
	on t.Id = s.Id collate SQL_Latin1_General_CP1_CI_AI
	when matched then update set
		t.[Name] = s.[Name],
		t.[Key] = s.[Key],
		t.[Memo] = s.[Memo],
		t.DateModified = getutcdate()
 	output inserted.Id into @rtable(Id);
	select @wfid = Id from @rtable;

	exec wfadm.[Catalog.Prop.Load] @UserId = @UserId, @Id = @wfid;
end
go

------------------------------------------------
create or alter procedure wfadm.[Catalog.Run.Load]
@UserId bigint,
@Id nvarchar(64)
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	set @Id = upper(@Id);

	declare @version int;
	select @version = max([Version]) from a2wf.Workflows where Id = @Id;

	select [Workflow!TWorkflow!Object] = null, [Id!!Id] = w.Id, w.[Name], [Version] = @version,
		[DateCreated!!Utc] = w.DateCreated, [DateModified!!Utc] = w.DateModified,
		w.Memo, w.[Key], CorrelationId = cast(null as nvarchar(255)),
		NeedPublish = cast(case when w.[Hash] = x.[Hash] then 0 else 1 end as bit),
		[Arguments!TArg!Array] = null
	from a2wf.[Catalog] w 
		left join a2wf.Workflows x on w.Id = x.Id and x.[Version] = @version
	where w.Id = @Id and x.[Version]  = @version;

	select [!TArg!Array] = null, wa.[Name], wa.[Type], wa.[Value],
		[!TWorkflow.Arguments!ParentId] = wa.WorkflowId
	from a2wf.WorkflowArguments wa 
	where wa.WorkflowId = @Id and [Version] = @version;
end
go
------------------------------------------------
create or alter procedure wfadm.[Catalog.Backup]
@UserId bigint,
@Ids nvarchar(max) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @src table(Id nvarchar(255));
	insert into @src(Id)
	select [value] from string_split(@Ids, nchar(11) /* \v in template */);

	select [Workflows!TWorkflow!Array] = null, c.[Id], c.[Format], c.[Name], c.[Key], c.Memo, c.Zoom
	from a2wf.[Catalog] c
	inner join @src s on c.Id = s.Id;

	select [Data!TData!Array] = null, c.[Id], c.[Body], c.[Svg]
	from a2wf.[Catalog] c
	inner join @src s on c.Id = s.Id;
end
go
------------------------------------------------
drop procedure if exists wfadm.[Catalog.Restore.Metadata];
drop procedure if exists wfadm.[Catalog.Restore.Update];
drop type if exists wfadm.[Catalog.Restore.TableType];
go
------------------------------------------------
create type wfadm.[Catalog.Restore.TableType] as table (
	[Id] nvarchar(255) not null,
	[Format] nvarchar(32) not null,
	[Body] nvarchar(max) null,
	[Name] nvarchar(255),
	[Memo] nvarchar(255),
	[Svg] nvarchar(max),
	[Key] nvarchar(32),
	Zoom float
);
go
------------------------------------------------
create or alter procedure wfadm.[Catalog.Restore.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @Workflows wfadm.[Catalog.Restore.TableType];
	select [Workflows!Workflows!Metadata] = null, * from @Workflows
end
go
------------------------------------------------
create or alter procedure wfadm.[Catalog.Restore.Update]
@UserId bigint,
@Workflows wfadm.[Catalog.Restore.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	merge a2wf.[Catalog] as t
	using @Workflows as s
	on t.Id = s.Id
	when matched then update set
		t.[Format] = s.[Format],
		t.Zoom = round(s.Zoom, 2),
		t.[Name] = s.[Name],
		t.[Key] = s.[Key],
		t.[Memo] = s.Memo,
		t.Body = s.Body,
		t.Svg = s.Svg,
		t.[Hash] = hashbytes(N'SHA2_256', s.Body),
		t.DateModified = getutcdate()
	when not matched then insert 
		(Id, [Format], Zoom, [Name], [Key], Memo, Body, Svg, [Hash]) values
		(s.Id, s.[Format], round(s.Zoom, 2), s.[Name], s.[Key], s.[Memo], s.Body, s.Svg, hashbytes(N'SHA2_256', s.Body));
end
go