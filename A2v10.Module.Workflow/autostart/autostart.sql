-- AUTOSTART
------------------------------------------------
create or alter procedure wfadm.[AutoStart.Index]
@UserId bigint,
@Id uniqueidentifier = null,
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
		[WorkflowName] = c.[Name],
		[!!RowCount] = t.rowcnt
	from a2wf.AutoStart a inner join @inst t on a.Id = t.Id
		left join a2wf.[Catalog] c on a.WorkflowId = c.Id
	order by t.rowno;

	select [!$System!] = null, [!AutoStart!Offset] = @Offset, [!AutoStart!PageSize] = @PageSize, 
		[!AutoStart!SortOrder] = @Order, [!AutoStart!SortDir] = @Dir;
end
go
------------------------------------------------
create or alter procedure wfadm.[AutoStart.Load]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [AutoStart!TAutoStart!Object] = null, [Id!!Id] = a.Id, a.[Version],
		[StartAt!!Utc] = StartAt, CorrelationId, a.Params, 
		[Workflow!TWorkflow!RefId] = a.WorkflowId,
		[DateCreated!!Utc] = a.DateCreated, [DateStarted!!Utc] = a.DateStarted,
		[WorkflowName] = c.[Name]
	from a2wf.AutoStart a
		inner join a2wf.[Catalog] c on a.WorkflowId = c.Id
	where a.Id = @Id;

	select [!TWorkflow!Map] = null, [Id!!Id] = c.Id, [Name!!Name] = c.[Name]
	from a2wf.[Catalog] c
		inner join a2wf.AutoStart a on a.WorkflowId = c.[Id]
	where a.Id = @Id;
end
go
------------------------------------------------
drop procedure if exists wfadm.[AutoStart.Metadata];
drop procedure if exists wfadm.[AutoStart.Update];
drop type if exists wfadm.[AutoStart.TableType];
go
------------------------------------------------
create type wfadm.[AutoStart.TableType] as table (
	Workflow nvarchar(255),
	StartAt datetime,
	TimezoneOffset int,
	CorrelationId nvarchar(255)
);
go
------------------------------------------------
create or alter procedure wfadm.[AutoStart.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @AutoStart wfadm.[AutoStart.TableType];
	select [AutoStart!AutoStart!Metadata] = null, * from @AutoStart;
end
go
------------------------------------------------
create or alter procedure wfadm.[AutoStart.Update]
@UserId bigint,
@AutoStart wfadm.[AutoStart.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read committed;

	-- SQL server time may be UTC!!!

	declare @rtable table(Id bigint);
	insert into a2wf.AutoStart (WorkflowId, CorrelationId, StartAt)
	output inserted.Id into @rtable(Id)
	select upper(Workflow), CorrelationId, dateadd(minute, TimezoneOffset, StartAt)
	from @AutoStart;

	declare @Id bigint;
	select @Id = Id from @rtable;
	exec wfadm.[AutoStart.Load] @UserId, @Id;
end
go
