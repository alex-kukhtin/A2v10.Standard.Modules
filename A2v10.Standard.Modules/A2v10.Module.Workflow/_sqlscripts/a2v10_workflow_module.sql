/* _sqlscripts/a2v10_workflow_module.sql */

-- SCHEMAS
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'wfadm')
	exec sp_executesql N'create schema wfadm authorization dbo';
go

grant execute on schema::wfadm to public;
go


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
		[DateCreated!!Utc] = w.DateCreated, w.Svg,
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
		[Svg] = cast(null as nvarchar(max)), [Version] = @version, 
		[DateCreated!!Utc] = DateCreated,
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
	Svg nvarchar(max)
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
		t.[Hash] = hashbytes(N'SHA2_256', s.Body)
	when not matched then insert 
		(Id, 
			[Name], [Body], Svg, [Format], [Hash]) values
		(upper(cast(newid() as nvarchar(64))), 
			s.[Name], s.[Body], s.Svg, N'text/xml', hashbytes(N'SHA2_256', s.Body))
	output inserted.Id into @rtable(Id);
	select @wfid = Id from @rtable;

	exec wfadm.[Catalog.Load] @UserId = @UserId, @Id = @wfid;
end
go

-- INSTANCE
------------------------------------------------
create or alter procedure wfadm.[Instance.Index]
@UserId bigint,
@Id nvarchar(64) = null,
@Offset int = 0,
@PageSize int = 20,
@Order nvarchar(255) = N'datemodified',
@Dir nvarchar(20) = N'desc'
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	set @Order = lower(@Order);
	set @Dir = lower(@Dir);

	declare @inst table (Id uniqueidentifier, rowno int identity(1,1), rowcnt int);

	insert into @inst(Id, rowcnt)
	select i.Id,
		count(*) over()
	from a2wf.Instances i
	order by 
		case when @Dir = N'asc' then
			case @Order 
				when N'id' then i.[Id]
			end
		end asc,
		case when @Dir = N'asc' then
			case @Order 
				when N'datecreated' then i.DateCreated
				when N'datemodified' then i.DateModified
			end
		end asc,
		case when @Dir = N'asc' then
			case @Order 
				when N'ExecutionStatus' then i.ExecutionStatus
			end
		end asc,
		case when @Dir = N'desc' then
			case @Order
				when N'id' then i.[Id]
			end
		end desc,
		case when @Dir = N'desc' then
			case @Order
				when N'datecreated' then i.DateCreated
				when N'datemodified' then i.DateModified
			end
		end desc,
		case when @Dir = N'desc' then
			case @Order
				when N'ExecutionStatus' then i.ExecutionStatus
			end
		end desc
	offset @Offset rows fetch next @PageSize rows only
	option (recompile);

	select [Instances!TInstance!Array] = null, [Id!!Id] = i.Id, w.[Name], i.[Version],
		i.ExecutionStatus, Lock, [LockDate!!Utc] = LockDate, i.CorrelationId,
		[DateCreated!!Utc] = i.DateCreated, [DateModified!!Utc] = i.DateModified,
		[Inboxes!TInbox!Array] = null,
		[!!RowCount] = t.rowcnt
	from a2wf.Instances i inner join @inst t on i.Id = t.Id
		inner join a2wf.[Workflows] w on i.WorkflowId = w.Id and i.[Version] = w.[Version]
	order by t.rowno;

	/*
	select [!TInbox!Array] = null, [Id!!Id] = i.Id, 
		Bookmark, [DateCreated!!Utc] = DateCreated, i.[Text], i.[User], i.[Role], i.[Url], i.[State],
		[Instance!TInstance.Inboxes!ParentId] = InstanceId
	from a2wf.Inbox i inner join @inst t on i.InstanceId = t.Id
	where i.Void = 0;
	*/

	select [Answer!TAnswer!Object] = null, [Answer] = cast(null as nvarchar(255));

	select [!$System!] = null, [!Instances!Offset] = @Offset, [!Instances!PageSize] = @PageSize, 
		[!Instances!SortOrder] = @Order, [!Instances!SortDir] = @Dir;
end
go
------------------------------------------------
create or alter procedure wfadm.[Instance.Delete]
@UserId bigint,
@Id uniqueidentifier = null
as
begin
	set nocount on;
	set transaction isolation level read committed;
	set xact_abort on;
	begin tran;
	--delete from a2wf.Inbox where InstanceId = @Id;
	exec a2wf.[Instance.Delete] @UserId = @UserId, @Id = @Id;
	commit tran;
end
go

------------------------------------------------
create or alter procedure wfadm.[Instance.Show.Load]
@UserId bigint,
@Id nvarchar(64) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Instance!TInstance!Object] = null, [Id!!Id] = i.Id, WorkflowId = i.WorkflowId, 
		[Version] = i.[Version], [Xml] = w.[Text], [DateModified!!Utc] = DateModified,
		[Track!TTrack!Array] = null, [UserTrack!TUserTrack!Array] = null,
		i.ExecutionStatus
	from a2wf.Instances i inner join a2wf.Workflows w on i.WorkflowId = w.Id and i.[Version] = w.[Version]
	where i.Id = @Id;

	select [!TTrack!Array] = null, Activity, [EventTime!!Utc] = max(EventTime),
		[!TInstance.Track!ParentId] = InstanceId 
	from a2wf.InstanceTrack where InstanceId = @Id 
		and [Kind] = 0 /*activity*/ and [Action] = 1 /*execute*/
	group by Activity, InstanceId
	order by max(EventTime);
end
go
------------------------------------------------
create or alter procedure wfadm.[Instance.Log.Load]
@UserId bigint,
@Id nvarchar(64) = null,
@Offset int = 0,
@PageSize int = 20
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Records!TRecord!Array] = null, [Id!!Id] = t.Id, t.Activity, t.[Message],
		[EventTime!!Utc] = t.EventTime, t.Kind, t.RecordNumber, t.[Action]
	from a2wf.InstanceTrack t
	where t.InstanceId = @Id and [Action] <> 0 -- skip start
	order by t.EventTime, RecordNumber;
end
go

------------------------------------------------
create or alter procedure wfadm.[Instance.Events.Load]
@UserId bigint,
@Id nvarchar(64) = null,
@Offset int = 0,
@PageSize int = 20
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Events!TEvent!Array] = null, e.Kind, e.[Event], e.[Name], e.[Text],
		[Pending!!Utc] = e.Pending
	from a2wf.InstanceEvents e
	where e.InstanceId = @Id
	order by e.Pending;
end
go
------------------------------------------------
create or alter procedure wfadm.[Instance.Variables.Load]
@UserId bigint,
@Id nvarchar(64) = null,
@Offset int = 0,
@PageSize int = 20
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Instance!TEvent!Array] = null, [Id!!Id] = i.Id, 
		Variables = cast(null as nvarchar(max))
	from a2wf.Instances i
	where i.Id = @Id;
end
go

-- AUTOSTART
------------------------------------------------
create or alter procedure wfadm.[AutoStart.Index]
@UserId bigint,
@Id nvarchar(64) = null,
@Offset int = 0,
@PageSize int = 20,
@Order nvarchar(255) = N'id',
@Dir nvarchar(20) = N'desc'
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	set @Order = lower(@Order);
	set @Dir = lower(@Dir);

	declare @inst table (Id bigint, rowno int identity(1,1), rowcnt int, [version] int);

	insert into @inst(Id, [version], rowcnt)
	select a.Id, a.[Version],
		count(*) over()
	from a2wf.AutoStart a
	order by 
		case when @Dir = N'asc' then
			case @Order 
				when N'id' then a.[Id]
			end
		end asc,
		case when @Dir = N'asc' then
			case @Order 
				when N'datecreated' then a.DateCreated
				when N'datestarted' then a.DateStarted
			end
		end asc,
		case when @Dir = N'desc' then
			case @Order
				when N'id' then a.[Id]
			end
		end desc,
		case when @Dir = N'desc' then
			case @Order
				when N'datecreated' then a.DateCreated
				when N'datestarted' then a.DateStarted
			end
		end desc,
		a.Id
	offset @Offset rows fetch next @PageSize rows only
	option (recompile);

	select [AutoStart!TAutoStart!Array] = null, [Id!!Id] = a.Id, a.[Version],
		[StartAt!!Utc] = a.StartAt, a.Lock, a.InstanceId, a.CorrelationId,
		[DateCreated!!Utc] = a.DateCreated, [DateStarted!!Utc] = a.DateStarted,
		[WorkflowName] = w.[Name],
		[!!RowCount] = t.rowcnt
	from a2wf.AutoStart a inner join @inst t on a.Id = t.Id
		left join a2wf.Workflows w on try_cast(a.WorkflowId as uniqueidentifier) = w.Id and a.[Version] = w.[Version]
	order by t.rowno;

	select [!$System!] = null, [!AutoStart!Offset] = @Offset, [!AutoStart!PageSize] = @PageSize, 
		[!AutoStart!SortOrder] = @Order, [!AutoStart!SortDir] = @Dir;
end
go


