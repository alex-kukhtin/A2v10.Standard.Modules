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

