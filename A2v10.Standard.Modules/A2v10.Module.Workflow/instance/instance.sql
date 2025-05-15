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

	select [Instance!TInstance!Object] = null, [Id!!Id] = i.Id, 
		[State!!Json] = [State],
		Variables = cast(null as nvarchar(max))
	from a2wf.Instances i
	where i.Id = @Id;
end
go
