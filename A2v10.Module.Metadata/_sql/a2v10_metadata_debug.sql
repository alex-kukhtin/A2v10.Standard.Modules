
/*
with T as (
	select fk.[name], [index] = fkc.constraint_column_id,
		[schema] = schema_name(fk.[schema_id]),
		[table] = object_name(fk.parent_object_id),
		[column] = c1.[name],
		refschema = schema_name(rt.[schema_id]),
		reftable = object_name(fk.referenced_object_id),
		refcolumn = c2.[name]
	from  sys.foreign_keys fk inner join sys.foreign_key_columns fkc on fkc.constraint_object_id = fk.[object_id]
		inner join sys.tables rt on fk.referenced_object_id = rt.[object_id]
		inner join sys.columns c1 on fkc.parent_column_id = c1.column_id and fkc.parent_object_id = c1.[object_id]
		inner join sys.columns c2 on fkc.referenced_column_id = c2.column_id and fkc.referenced_object_id = c2.[object_id]
	where schema_name(fk.[schema_id]) = 'doc' and object_name(fk.parent_object_id) = 'Contracts'
)
select [name], columns = string_agg([column], N','), 
refschema, reftable, refcolumns = string_agg(refcolumn, N',')
from T
group by [name], refschema, reftable;
*/


--exec a2meta.[Config.Load] 99

/*
declare @Schema nvarchar(255) = N'doc';
declare @Table nvarchar(255) = N'ClientOrders';

exec a2meta.[Table.Schema] @Schema, @Table;
--exec a2meta.[Config.Load] 99 @Schema, @Table;
*/

--select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where CONSTRAINT_NAME = N'FK_Columns_Parent_Catalog'

/*
	select [!TColumn!Array] = null, [Name!!Id] = COLUMN_NAME, DataType = DATA_TYPE, 
		[MaxLength] = CHARACTER_MAXIMUM_LENGTH,
		[Reference!TReference!Object] = null,
		[!TTable.Columns!ParentId] = @tableId
	from INFORMATION_SCHEMA.COLUMNS where 
		TABLE_SCHEMA = @Schema collate SQL_Latin1_General_CP1_CI_AI 
		and TABLE_NAME = @Table collate SQL_Latin1_General_CP1_CI_AI 
	order by ORDINAL_POSITION;
*/

/*
	with T as (
		select [Name] = fk.[name], [index] = fkc.constraint_column_id,
			[schema] = schema_name(fk.[schema_id]),
			[table] = object_name(fk.parent_object_id),
			[Column] = c1.[name],
			RefSchema = schema_name(rt.[schema_id]),
			RefTable = object_name(fk.referenced_object_id),
			RefColumn = c2.[name]
		from  sys.foreign_keys fk inner join sys.foreign_key_columns fkc on fkc.constraint_object_id = fk.[object_id]
			inner join sys.tables rt on fk.referenced_object_id = rt.[object_id]
			inner join sys.columns c1 on fkc.parent_column_id = c1.column_id and fkc.parent_object_id = c1.[object_id]
			inner join sys.columns c2 on fkc.referenced_column_id = c2.column_id and fkc.referenced_object_id = c2.[object_id]
		where schema_name(fk.[schema_id]) = @Schema collate SQL_Latin1_General_CP1_CI_AI
		and object_name(fk.parent_object_id) = @Table collate SQL_Latin1_General_CP1_CI_AI 
	)
	select [!TReference!Object] = null, RefSchema, RefTable, RefColumn,
		[!TColumn.Reference!ParentId] = [Column]
	from T;

	-- exetending properties
	-- https://www.mssqltips.com/sqlservertip/5384/working-with-sql-server-extended-properties/
*/


/*
drop table if exists a2meta.[Application]
drop table if exists a2meta.[ApplyMapping]
drop table if exists a2meta.[Apply]
drop table if exists a2meta.[DefaultColumns]
drop table if exists a2meta.[DetailsKinds];
drop table if exists a2meta.[Forms]
drop table if exists a2meta.[Columns]
drop table if exists a2meta.[Items]
drop table if exists a2meta.[Catalog]

select * from a2meta.DefaultColumns;

select * from a2meta.ODataTables;
select * from a2meta.ODataColumns order by [Name];
*/

