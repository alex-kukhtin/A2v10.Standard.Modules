/* _sqlscripts/a2v10_admin_module.sql */

-- ADMIN SCHEMAS
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'adm')
	exec sp_executesql N'create schema adm authorization dbo';
go

grant execute on schema::adm to public;
go




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

