-- SCHEMAS
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'wfadm')
	exec sp_executesql N'create schema wfadm authorization dbo';
go

grant execute on schema::wfadm to public;
go

