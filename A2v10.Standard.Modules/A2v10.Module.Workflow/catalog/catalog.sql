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
		w.Svg, w.Zoom, w.Memo,
		NeedPublish = cast(case when w.[Hash] = x.[Hash] then 0 else 1 end as bit),
		[Arguments!TArg!Array] = null
	from a2wf.[Catalog] w left join @wftable t on w.Id = t.Id
		left join a2wf.Workflows x on w.Id = x.Id and x.[Version] = t.[Version]
	order by w.DateCreated desc;

	select [!TArg!Array] = null, wa.[Name], wa.[Type], wa.[Value],
		[!TWorkflow.Arguments!ParentId] = t.Id
	from a2wf.WorkflowArguments wa inner join @wftable t on wa.WorkflowId = t.Id and wa.[Version] = t.[Version]
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

	declare @version int, @hash varbinary(64);
	select @version = max([Version]) from a2wf.Workflows where Id = @Id;
	select @hash = Hash from a2wf.Workflows where Id = @Id and [Version] = @version;

	select [Workflow!TWorkflow!Object] = null, [Id!!Id] = Id, [Name!!Name] = [Name], [Body],
		[Svg] = cast(null as nvarchar(max)), [Version] = @version,  Zoom,
		[DateCreated!!Utc] = DateCreated, [DateModified!!Utc] = DateModified,
		NeedPublish = cast(case when [Hash] = @hash then 0 else 1 end as bit)
	from a2wf.[Catalog] 
	where Id = @Id
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
	on t.Id = s.Id
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
