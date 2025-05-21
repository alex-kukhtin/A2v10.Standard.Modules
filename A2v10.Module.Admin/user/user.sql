-- USER
------------------------------------------------
create or alter procedure adm.[User.Index]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [Users!TUser!Array] = null
	where 0 <> 0;
end
go
