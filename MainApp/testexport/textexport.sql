create or alter procedure cat.[TestExport.Load]
@UserId bigint,
@Offset int = 0,
@PageSize int = 20,
@Order nvarchar(255) = N'datecreated',
@Dir nvarchar(20) = N'desc',
@Fragment nvarchar(255) = null,
@From date = null,
@To date = null,
@From2 date = null,
@To2 date = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;


	declare @fr nvarchar(255) = N'%' + @Fragment + N'%';
	set @From = isnull(@From, getdate());
	set @To = isnull(@To, getdate());

	set @From2 = isnull(@From2, getdate());
	set @To2 = isnull(@To2, getdate());

	select [Agents!TAgent!Array] = null, [Id!!Id] = Id, [Name], [Date], [Store], Memo,
		[From]=@From, [To] = @To, From2 = @From2, To2 = @To2,
		[!!RowCount] = count(*) over ()
	from cat.Agents
	where [Date] >= @From and [Date] <= @To
	and (@Fragment is null or [Name] like @fr or [Memo] like @fr);

	select [!$System!] = null,  [!Agents!PageSize]  = @PageSize, 
		[!Agents!SortOrder] = @Order, [!Agents!SortDir] = @Dir,
		[!Agents!Offset] = @Offset,
		[!Agents.Fragment!Filter] = @Fragment,
		[!Agents.Period.From!Filter] = @From,
		[!Agents.Period.To!Filter] = @To,
		[!Agents.Period2.From!Filter] = @From2,
		[!Agents.Period2.To!Filter] = @To2;
end
go

create or alter procedure cat.[TestExport.Load.Export]
@UserId bigint,
@Fragment nvarchar(255) = null,
@From date = null,
@To date = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	throw 60000, @To, 0;
end
go