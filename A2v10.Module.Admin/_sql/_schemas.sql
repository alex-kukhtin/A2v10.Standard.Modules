-- ADMIN SCHEMAS
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'adm')
	exec sp_executesql N'create schema adm authorization dbo';
go

grant execute on schema::adm to public;
go



