-- MIGRATIONS
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = N'a2wf' and TABLE_NAME = N'Catalog' and COLUMN_NAME = N'Zoom')
	alter table a2wf.[Catalog] add Zoom float constraint DF_Catalog_Zoom default(1) with values;
go

------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.COLUMNS where TABLE_SCHEMA = N'a2wf' and TABLE_NAME = N'Catalog' and COLUMN_NAME = N'DateModified')
	alter table a2wf.[Catalog] add DateModified datetime constraint DF_Catalog_DateModified default(getutcdate()) with values;
go
