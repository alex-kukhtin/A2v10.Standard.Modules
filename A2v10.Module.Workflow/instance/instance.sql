-- INSTANCE
------------------------------------------------
create or alter procedure wfadm.[Instance.Index]
@UserId bigint,
@Id nvarchar(64) = null,
@Offset int = 0,
@PageSize int = 20,
@Order nvarchar(255) = N'datemodified',
@Dir nvarchar(20) = N'desc',
@Workflow nvarchar(255) = null,
@State nvarchar(32) = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	set @Order = lower(@Order);
	set @Dir = lower(@Dir);
	set @Workflow = upper(@Workflow);

	set @State = nullif(@State, N'');

	declare @inst table (Id uniqueidentifier, rowno int identity(1,1), rowcnt int);

	insert into @inst(Id, rowcnt)
	select i.Id,
		count(*) over()
	from a2wf.Instances i
		inner join a2wf.[Workflows] w on i.WorkflowId = w.Id and i.[Version] = w.[Version]
	where (@Workflow is null or w.Id = @Workflow)
		and (@State is null or i.[ExecutionStatus] = @State)
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
		[Inboxes!TInbox!Array] = null, [Bookmarks!TBookmark!Array] = null,
		[!!RowCount] = t.rowcnt
	from a2wf.Instances i inner join @inst t on i.Id = t.Id
		inner join a2wf.[Workflows] w on i.WorkflowId = w.Id and i.[Version] = w.[Version]
	order by t.rowno;

	-- Inbox MUST be created
	select [!TInbox!Array] = null, [Id!!Id] = i.Id, 
		Bookmark, [DateCreated!!Utc] = DateCreated, i.[Text], i.[User], i.[Role], i.[Url], i.[State],
		[Instance!TInstance.Inboxes!ParentId] = InstanceId
	from a2wf.Inbox i inner join @inst t on i.InstanceId = t.Id
	where i.Void = 0;

	select [!TBookmark!Array] = null, i.Bookmark,
		[Instance!TInstance.Bookmarks!ParentId] = InstanceId
	from a2wf.InstanceBookmarks i inner join @inst t on i.InstanceId = t.Id;

	select [Answer!TAnswer!Object] = null, [Answer] = cast(null as nvarchar(255));

	select [!TWorkflow!Map] = null, [Id!!Id] = Id, [Name!!Name] = [Name]
	from a2wf.Workflows
	where Id = @Workflow;

	select [StartWorkflow!TStartWF!Object] = null, [Id!!Id] = Id,
		[Arguments!TArg!Array] = null
	from a2wf.[Catalog] where 0 <> 0;

	select [!TArg!Array] = null, wa.[Name], wa.[Type], wa.[Value],
		[!TStartWF.Arguments!ParentId] = wa.WorkflowId
	from a2wf.WorkflowArguments wa
	where 0 <> 0;

	select [!$System!] = null, [!Instances!Offset] = @Offset, [!Instances!PageSize] = @PageSize, 
		[!Instances!SortOrder] = @Order, [!Instances!SortDir] = @Dir,
		[!Instances.Workflow.TWorkflow.RefId!Filter] = @Workflow, 
		[!Instances.State!Filter] = isnull(@State, N'');
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
	
	delete from a2wf.Inbox where InstanceId = @Id;
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

	with TE as(
		select InstanceId, Activity
		from a2wf.InstanceTrack where InstanceId = @Id
			and [Kind] = 0 /*activity*/ and [Action] in (
				1 /*execute*/, 7 /*inbox*/, 4 /* Event */)
		group by InstanceId, Activity
	)
	select [!TTrack!Array] = null, TE.Activity,
		IsIdle = cast(
			case when b.Bookmark is not null or e.[Event] is not null
			then 1 else 0 end as bit
		),
		[!TInstance.Track!ParentId] = TE.InstanceId 
	from TE
		left join a2wf.InstanceBookmarks b on TE.InstanceId = b.InstanceId and TE.Activity = b.Activity
		left join a2wf.InstanceEvents e on TE.InstanceId = e.InstanceId and TE.Activity = e.[Event];
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
		[EventTime!!Utc] = t.EventTime, t.Kind, t.RecordNumber, t.[Action],
		[!!RowCount] = count(*) over()
	from a2wf.InstanceTrack t
	where t.InstanceId = @Id and [Action] <> 0 -- skip start
	order by Id desc
	offset @Offset rows fetch next @PageSize rows only
	option (recompile);

	select [!$System!] = null, [!Records!Offset] = @Offset, [!Records!PageSize] = @PageSize;
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
------------------------------------------------
create or alter procedure wfadm.[Instance.Unlock]
@UserId bigint,
@Id uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read committed;

	update a2wf.Instances set Lock = null, LockDate = null where Id = @Id;
end
go