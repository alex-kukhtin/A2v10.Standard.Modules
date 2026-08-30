/* METADATA SEED. Version: 10.1.8653 */
begin
    set nocount on;
    declare @tables table([schema] sysname, [table] sysname);
    declare @columns table([schema] sysname, [table] sysname, [column] sysname, [datatype] sysname,
        [length] int, [precision] tinyint, [scale] tinyint, [nullable] bit,
        [ref_schema] nvarchar(128), [ref_table] nvarchar(128), [default] nvarchar(128));

    insert into @tables([schema], [table]) values
    	(N'cat', N'$Tags'),
		(N'cat', N'Agent$TagEntries'),
		(N'cat', N'AgentAddresses'),
		(N'cat', N'Agents'),
		(N'cat', N'Items'),
		(N'cat', N'StoreAddresses'),
		(N'cat', N'Stores'),
		(N'cat', N'Units'),
		(N'doc', N'DocumentRows'),
		(N'doc', N'StockDocuments'),
		(N'jrn', N'StockJournal');

    insert into @columns([schema], [table], [column], [datatype],
        [length], [precision], [scale], [nullable], [ref_schema], [ref_table], [default]) values
    	(N'cat', N'$Tags', N'Color', N'nvarchar', 32, null, null, 1, null, null, null),
		(N'cat', N'$Tags', N'For', N'nvarchar', 64, null, null, 1, null, null, null),
		(N'cat', N'$Tags', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'$Tags', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'$Tags', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Agent$TagEntries', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Agent$TagEntries', N'Owner', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Agent$TagEntries', N'Tag', N'platformid', null, null, null, 1, null, null, null),
		(N'cat', N'AgentAddresses', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'AgentAddresses', N'Owner', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'AgentAddresses', N'RowNo', N'int', null, null, null, 1, null, null, null),
		(N'cat', N'AgentAddresses', N'Text', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Agents', N'Date', N'date', null, null, null, 1, null, null, null),
		(N'cat', N'Agents', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Agents', N'IsSystem', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Agents', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Agents', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Agents', N'Store', N'platformid', null, null, null, 1, N'cat', N'Stores', null),
		(N'cat', N'Agents', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Agents', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'cat', N'Items', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Items', N'IsSystem', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Items', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Items', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Items', N'Unit', N'platformid', null, null, null, 1, N'cat', N'Units', null),
		(N'cat', N'Items', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Items', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'cat', N'StoreAddresses', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'StoreAddresses', N'Owner', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'StoreAddresses', N'RowNo', N'int', null, null, null, 1, null, null, null),
		(N'cat', N'StoreAddresses', N'Text', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Stores', N'Agent', N'platformid', null, null, null, 1, N'cat', N'Agents', null),
		(N'cat', N'Stores', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Stores', N'IsSystem', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Stores', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Stores', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Stores', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Stores', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'cat', N'Units', N'Denom', N'money', null, null, null, 1, null, null, null),
		(N'cat', N'Units', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Units', N'IsSystem', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Units', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Units', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Units', N'Short', N'nvarchar', 8, null, null, 1, null, null, null),
		(N'cat', N'Units', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Units', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'doc', N'DocumentRows', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'doc', N'DocumentRows', N'Item', N'platformid', null, null, null, 1, N'cat', N'Items', null),
		(N'doc', N'DocumentRows', N'Kind', N'nvarchar', 64, null, null, 1, null, null, null),
		(N'doc', N'DocumentRows', N'Owner', N'platformid', null, null, null, 0, null, null, null),
		(N'doc', N'DocumentRows', N'Price', N'decimal', null, 19, 6, 1, null, null, null),
		(N'doc', N'DocumentRows', N'Qty', N'decimal', null, 19, 6, 1, null, null, null),
		(N'doc', N'DocumentRows', N'RowNo', N'int', null, null, null, 1, null, null, null),
		(N'doc', N'DocumentRows', N'Sum', N'decimal', null, 19, 4, 1, null, null, null),
		(N'doc', N'DocumentRows', N'Unit', N'platformid', null, null, null, 1, N'cat', N'Units', null),
		(N'doc', N'StockDocuments', N'Agent', N'platformid', null, null, null, 1, N'cat', N'Agents', null),
		(N'doc', N'StockDocuments', N'Date', N'date', null, null, null, 1, null, null, null),
		(N'doc', N'StockDocuments', N'Done', N'bit', null, null, null, 0, null, null, N'0'),
		(N'doc', N'StockDocuments', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'doc', N'StockDocuments', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'doc', N'StockDocuments', N'Number', N'nvarchar', 64, null, null, 1, null, null, null),
		(N'doc', N'StockDocuments', N'Operation', N'nvarchar', 64, null, null, 1, N'doc', N'Operations', null),
		(N'doc', N'StockDocuments', N'StoreFrom', N'platformid', null, null, null, 1, N'cat', N'Stores', null),
		(N'doc', N'StockDocuments', N'StoreTo', N'platformid', null, null, null, 1, N'cat', N'Stores', null),
		(N'doc', N'StockDocuments', N'Sum', N'decimal', null, 19, 4, 1, null, null, null),
		(N'doc', N'StockDocuments', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'doc', N'StockDocuments', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'jrn', N'StockJournal', N'Agent', N'platformid', null, null, null, 1, N'cat', N'Agents', null),
		(N'jrn', N'StockJournal', N'Date', N'date', null, null, null, 1, null, null, null),
		(N'jrn', N'StockJournal', N'Detail', N'platformid', null, null, null, 1, null, null, null),
		(N'jrn', N'StockJournal', N'Document', N'platformid', null, null, null, 1, N'doc', N'StockDocuments', null),
		(N'jrn', N'StockJournal', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'jrn', N'StockJournal', N'InOut', N'smallint', null, null, null, 1, null, null, null),
		(N'jrn', N'StockJournal', N'Item', N'platformid', null, null, null, 1, N'cat', N'Items', null),
		(N'jrn', N'StockJournal', N'Operation', N'nvarchar', 64, null, null, 1, N'doc', N'Operations', null),
		(N'jrn', N'StockJournal', N'Qty', N'decimal', null, 19, 6, 1, null, null, null),
		(N'jrn', N'StockJournal', N'Store', N'platformid', null, null, null, 1, N'cat', N'Stores', null),
		(N'jrn', N'StockJournal', N'Sum', N'decimal', null, 19, 4, 1, null, null, null);

    -- merge tables
    merge a2meta.Tables as t
    using @tables as s
    on t.[schema] = s.[schema] and t.[table] = s.[table]
    when not matched then insert([schema], [table]) values
       (s.[schema], s.[table])
    when not matched by source then delete;

    -- merge columns
    merge a2meta.Columns as t
    using @columns as s
    on t.[schema] = s.[schema] and t.[table] = s.[table] and t.[column] = s.[column]
    when matched then update set
        t.[datatype] = s.[datatype],
        t.[length] = s.[length],
        t.[precision] = s.[precision],
        t.[scale] = s.[scale],
        t.[nullable] = s.[nullable],
        t.[ref_schema] = s.[ref_schema],
        t.[ref_table] = s.[ref_table],
        t.[default] = s.[default]
    when not matched then insert
        ([schema], [table], [column], [datatype],
         [length], [precision], [scale], [nullable], [ref_schema], [ref_table], [default]) values
        (s.[schema], s.[table], s.[column], s.[datatype],
         s.[length], s.[precision], s.[scale], s.[nullable], s.[ref_schema], s.[ref_table], s.[default])
    when not matched by source then delete;
end
go

-- PLATFORM ID TYPE
------------------------------------------------
if type_id(N'dbo.platformid') is null
	create type dbo.platformid from bigint;
go        
-- SCHEMAS
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'doc')
	exec sp_executesql N'create schema doc authorization dbo';
go
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'cat')
	exec sp_executesql N'create schema cat authorization dbo';
go
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'jrn')
	exec sp_executesql N'create schema jrn authorization dbo';
go
grant select, insert, update, execute on schema::doc to public;
grant select, insert, update, execute on schema::cat to public;
grant select, insert, update, execute on schema::jrn to public;
go

-- TABLES
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'doc' and SEQUENCE_NAME = N'SQ_StockDocuments')
	create sequence doc.[SQ_StockDocuments] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'doc' and TABLE_NAME=N'StockDocuments')
create table doc.[StockDocuments]
(
    [Id] platformid not null
       constraint DF_StockDocuments_Id default(next value for doc.[SQ_StockDocuments]),
    [Void] bit not null
       constraint DF_StockDocuments_Void default(0),
    [Done] bit not null
       constraint DF_StockDocuments_Done default(0),
    [Date] date,
    [rv] rowversion not null,
    [Memo] nvarchar(255),
    [Number] nvarchar(64),
    [Operation] nvarchar(64),
    [StoreFrom] platformid,
    [StoreTo] platformid,
    [Agent] platformid,
    [Sum] decimal(19, 4),
    constraint PK_StockDocuments primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'doc' and SEQUENCE_NAME = N'SQ_DocumentRows')
	create sequence doc.[SQ_DocumentRows] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'doc' and TABLE_NAME=N'DocumentRows')
create table doc.[DocumentRows]
(
    [Id] platformid not null
       constraint DF_DocumentRows_Id default(next value for doc.[SQ_DocumentRows]),
    [Owner] platformid not null,
    [RowNo] int,
    [Kind] nvarchar(64),
    [Qty] decimal(19, 6),
    [Price] decimal(19, 6),
    [Sum] decimal(19, 4),
    [Item] platformid,
    [Unit] platformid,
    constraint PK_DocumentRows primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Agents')
	create sequence cat.[SQ_Agents] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Agents')
create table cat.[Agents]
(
    [Id] platformid not null
       constraint DF_Agents_Id default(next value for cat.[SQ_Agents]),
    [Void] bit not null
       constraint DF_Agents_Void default(0),
    [IsSystem] bit not null
       constraint DF_Agents_IsSystem default(0),
    [rv] rowversion not null,
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Date] date,
    [Store] platformid,
    constraint PK_Agents primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Agent$TagEntries')
	create sequence cat.[SQ_Agent$TagEntries] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Agent$TagEntries')
create table cat.[Agent$TagEntries]
(
    [Id] platformid not null
       constraint DF_Agent$TagEntries_Id default(next value for cat.[SQ_Agent$TagEntries]),
    [Owner] platformid not null,
    [Tag] platformid,
    constraint PK_Agent$TagEntries primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_AgentAddresses')
	create sequence cat.[SQ_AgentAddresses] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'AgentAddresses')
create table cat.[AgentAddresses]
(
    [Id] platformid not null
       constraint DF_AgentAddresses_Id default(next value for cat.[SQ_AgentAddresses]),
    [Owner] platformid not null,
    [RowNo] int,
    [Text] nvarchar(255),
    constraint PK_AgentAddresses primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Items')
	create sequence cat.[SQ_Items] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Items')
create table cat.[Items]
(
    [Id] platformid not null
       constraint DF_Items_Id default(next value for cat.[SQ_Items]),
    [Void] bit not null
       constraint DF_Items_Void default(0),
    [IsSystem] bit not null
       constraint DF_Items_IsSystem default(0),
    [rv] rowversion not null,
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Unit] platformid,
    constraint PK_Items primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Stores')
	create sequence cat.[SQ_Stores] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Stores')
create table cat.[Stores]
(
    [Id] platformid not null
       constraint DF_Stores_Id default(next value for cat.[SQ_Stores]),
    [Void] bit not null
       constraint DF_Stores_Void default(0),
    [IsSystem] bit not null
       constraint DF_Stores_IsSystem default(0),
    [rv] rowversion not null,
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Agent] platformid,
    constraint PK_Stores primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_StoreAddresses')
	create sequence cat.[SQ_StoreAddresses] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'StoreAddresses')
create table cat.[StoreAddresses]
(
    [Id] platformid not null
       constraint DF_StoreAddresses_Id default(next value for cat.[SQ_StoreAddresses]),
    [Owner] platformid not null,
    [RowNo] int,
    [Text] nvarchar(255),
    constraint PK_StoreAddresses primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Units')
	create sequence cat.[SQ_Units] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Units')
create table cat.[Units]
(
    [Id] platformid not null
       constraint DF_Units_Id default(next value for cat.[SQ_Units]),
    [Void] bit not null
       constraint DF_Units_Void default(0),
    [IsSystem] bit not null
       constraint DF_Units_IsSystem default(0),
    [rv] rowversion not null,
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Short] nvarchar(8),
    [Denom] money,
    constraint PK_Units primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'jrn' and SEQUENCE_NAME = N'SQ_StockJournal')
	create sequence jrn.[SQ_StockJournal] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'jrn' and TABLE_NAME=N'StockJournal')
create table jrn.[StockJournal]
(
    [Id] platformid not null
       constraint DF_StockJournal_Id default(next value for jrn.[SQ_StockJournal]),
    [Date] date,
    [InOut] smallint,
    [Document] platformid,
    [Operation] nvarchar(64),
    [Detail] platformid,
    [Qty] decimal(19, 6),
    [Sum] decimal(19, 4),
    [Store] platformid,
    [Agent] platformid,
    [Item] platformid,
    constraint PK_StockJournal primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_$Tags')
	create sequence cat.[SQ_$Tags] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'$Tags')
create table cat.[$Tags]
(
    [Id] platformid not null
       constraint DF_$Tags_Id default(next value for cat.[SQ_$Tags]),
    [For] nvarchar(64),
    [Name] nvarchar(255),
    [Color] nvarchar(32),
    [Memo] nvarchar(255),
    constraint PK_$Tags primary key (Id)
);
go

-- TABLE TYPES
------------------------------------------------
drop type if exists dbo.[PlatformId.TableType];
create type dbo.[PlatformId.TableType] as table
(
    [Id] platformid
);
go
------------------------------------------------
drop type if exists doc.[Document.Meta.TableType];
create type doc.[Document.Meta.TableType] as table
(
    [Id] platformid,
    [Void] bit,
    [Done] bit,
    [Date] date,
    [rv] varbinary(8),
    [Memo] nvarchar(255),
    [Number] nvarchar(64),
    [Operation] nvarchar(64),
    [StoreFrom] platformid,
    [StoreTo] platformid,
    [Agent] platformid,
    [Sum] decimal(19, 4)
);
go
------------------------------------------------
drop type if exists doc.[Row.Meta.TableType];
create type doc.[Row.Meta.TableType] as table
(
    [Id] platformid,
    [Owner] platformid,
    [RowNo] int,
    [Kind] nvarchar(64),
    [Qty] decimal(19, 6),
    [Price] decimal(19, 6),
    [Sum] decimal(19, 4),
    [Item] platformid,
    [Unit] platformid
);
go
------------------------------------------------
drop type if exists cat.[Agent.Meta.TableType];
create type cat.[Agent.Meta.TableType] as table
(
    [Id] platformid,
    [Void] bit,
    [IsSystem] bit,
    [rv] varbinary(8),
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Date] date,
    [Store] platformid
);
go
------------------------------------------------
drop type if exists cat.[AgentAddress.Meta.TableType];
create type cat.[AgentAddress.Meta.TableType] as table
(
    [Id] platformid,
    [Owner] platformid,
    [RowNo] int,
    [Text] nvarchar(255)
);
go
------------------------------------------------
drop type if exists cat.[Item.Meta.TableType];
create type cat.[Item.Meta.TableType] as table
(
    [Id] platformid,
    [Void] bit,
    [IsSystem] bit,
    [rv] varbinary(8),
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Unit] platformid
);
go
------------------------------------------------
drop type if exists cat.[Store.Meta.TableType];
create type cat.[Store.Meta.TableType] as table
(
    [Id] platformid,
    [Void] bit,
    [IsSystem] bit,
    [rv] varbinary(8),
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Agent] platformid
);
go
------------------------------------------------
drop type if exists cat.[Address.Meta.TableType];
create type cat.[Address.Meta.TableType] as table
(
    [Id] platformid,
    [Owner] platformid,
    [RowNo] int,
    [Text] nvarchar(255)
);
go
------------------------------------------------
drop type if exists cat.[Unit.Meta.TableType];
create type cat.[Unit.Meta.TableType] as table
(
    [Id] platformid,
    [Void] bit,
    [IsSystem] bit,
    [rv] varbinary(8),
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Short] nvarchar(8),
    [Denom] money
);
go
------------------------------------------------
drop type if exists cat.[Tag.Meta.TableType];
create type cat.[Tag.Meta.TableType] as table
(
    [Id] platformid,
    [For] nvarchar(64),
    [Name] nvarchar(255),
    [Color] nvarchar(32),
    [Memo] nvarchar(255)
);
go

-- SYNC DATABASE SCHEMA
exec a2meta.[SyncSchema]
go

-- FOREIGN KEYS
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_Operation_Operations')
    alter table doc.[StockDocuments] add
        constraint FK_StockDocuments_Operation_Operations foreign key ([Operation]) references op.[Operations]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_StoreFrom_Stores')
    alter table doc.[StockDocuments] add
        constraint FK_StockDocuments_StoreFrom_Stores foreign key ([StoreFrom]) references cat.[Stores]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_StoreTo_Stores')
    alter table doc.[StockDocuments] add
        constraint FK_StockDocuments_StoreTo_Stores foreign key ([StoreTo]) references cat.[Stores]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_Agent_Agents')
    alter table doc.[StockDocuments] add
        constraint FK_StockDocuments_Agent_Agents foreign key ([Agent]) references cat.[Agents]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'DocumentRows' and CONSTRAINT_NAME = N'FK_DocumentRows_Owner_StockDocuments')
    alter table doc.[DocumentRows] add
        constraint FK_DocumentRows_Owner_StockDocuments foreign key ([Owner]) references doc.[StockDocuments]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'DocumentRows' and CONSTRAINT_NAME = N'FK_DocumentRows_Item_Items')
    alter table doc.[DocumentRows] add
        constraint FK_DocumentRows_Item_Items foreign key ([Item]) references cat.[Items]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'DocumentRows' and CONSTRAINT_NAME = N'FK_DocumentRows_Unit_Units')
    alter table doc.[DocumentRows] add
        constraint FK_DocumentRows_Unit_Units foreign key ([Unit]) references cat.[Units]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Agents' and CONSTRAINT_NAME = N'FK_Agents_Store_Stores')
    alter table cat.[Agents] add
        constraint FK_Agents_Store_Stores foreign key ([Store]) references cat.[Stores]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Agent$TagEntries' and CONSTRAINT_NAME = N'FK_Agent$TagEntries_Owner_Agents')
    alter table cat.[Agent$TagEntries] add
        constraint FK_Agent$TagEntries_Owner_Agents foreign key ([Owner]) references cat.[Agents]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Agent$TagEntries' and CONSTRAINT_NAME = N'FK_Agent$TagEntries_Tag_$Tags')
    alter table cat.[Agent$TagEntries] add
        constraint FK_Agent$TagEntries_Tag_$Tags foreign key ([Tag]) references cat.[$Tags]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'AgentAddresses' and CONSTRAINT_NAME = N'FK_AgentAddresses_Owner_Agents')
    alter table cat.[AgentAddresses] add
        constraint FK_AgentAddresses_Owner_Agents foreign key ([Owner]) references cat.[Agents]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Items' and CONSTRAINT_NAME = N'FK_Items_Unit_Units')
    alter table cat.[Items] add
        constraint FK_Items_Unit_Units foreign key ([Unit]) references cat.[Units]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Stores' and CONSTRAINT_NAME = N'FK_Stores_Agent_Agents')
    alter table cat.[Stores] add
        constraint FK_Stores_Agent_Agents foreign key ([Agent]) references cat.[Agents]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'StoreAddresses' and CONSTRAINT_NAME = N'FK_StoreAddresses_Owner_Stores')
    alter table cat.[StoreAddresses] add
        constraint FK_StoreAddresses_Owner_Stores foreign key ([Owner]) references cat.[Stores]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Document_StockDocuments')
    alter table jrn.[StockJournal] add
        constraint FK_StockJournal_Document_StockDocuments foreign key ([Document]) references doc.[StockDocuments]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Operation_Operations')
    alter table jrn.[StockJournal] add
        constraint FK_StockJournal_Operation_Operations foreign key ([Operation]) references op.[Operations]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Store_Stores')
    alter table jrn.[StockJournal] add
        constraint FK_StockJournal_Store_Stores foreign key ([Store]) references cat.[Stores]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Agent_Agents')
    alter table jrn.[StockJournal] add
        constraint FK_StockJournal_Agent_Agents foreign key ([Agent]) references cat.[Agents]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Item_Items')
    alter table jrn.[StockJournal] add
        constraint FK_StockJournal_Item_Items foreign key ([Item]) references cat.[Items]([Id]);
go

