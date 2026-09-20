/* METADATA SEED. Version: 10.1.8655 */
begin
    set nocount on;
    declare @tables table([schema] sysname, [table] sysname, [xtra] nvarchar(64),
        [master_schema] nvarchar(128), [master_table] nvarchar(128),
        [master_column] nvarchar(128));
    declare @columns table([schema] sysname, [table] sysname, [column] sysname, [datatype] sysname,
        [length] int, [precision] tinyint, [scale] tinyint, [nullable] bit,
        [ref_schema] nvarchar(128), [ref_table] nvarchar(128), [default] nvarchar(128));

    insert into @tables([schema], [table], [xtra],
        [master_schema], [master_table], [master_column]) values
    	(N'cat', N'$Tags', null, null, null, null),
		(N'cat', N'Agent$TagEntries', null, N'cat', N'Agents', N'Agent'),
		(N'cat', N'AgentAddresses', null, N'cat', N'Agents', N'Agent'),
		(N'cat', N'Agents', null, null, null, null),
		(N'cat', N'Items', null, null, null, null),
		(N'cat', N'StoreAddresses', null, N'cat', N'Stores', N'Store'),
		(N'cat', N'Stores', null, null, null, null),
		(N'cat', N'Units', null, null, null, null),
		(N'doc', N'Autonum$Values', null, null, null, null),
		(N'doc', N'Autonums', N'950f0f94c55e5f5c8b759845d52be6d4865d117d247089d03421f2c7a857da35', null, null, null),
		(N'doc', N'DocumentRows', null, N'doc', N'StockDocuments', N'Document'),
		(N'doc', N'StockDocuments', null, null, null, null),
		(N'enm', N'VatRates', N'6ab7079eb35144fc75a7700558c5af29af4bc013ac756bd9ec42242a22da9714', null, null, null),
		(N'jrn', N'StockJournal', null, null, null, null);

    insert into @columns([schema], [table], [column], [datatype],
        [length], [precision], [scale], [nullable], [ref_schema], [ref_table], [default]) values
    	(N'cat', N'$Tags', N'Color', N'nvarchar', 32, null, null, 1, null, null, null),
		(N'cat', N'$Tags', N'For', N'nvarchar', 64, null, null, 1, null, null, null),
		(N'cat', N'$Tags', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'$Tags', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'$Tags', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'$Tags', N'UserCreated', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'$Tags', N'UserModified', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'$Tags', N'UtcDateCreated', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'$Tags', N'UtcDateModified', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'Agent$TagEntries', N'Agent', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Agent$TagEntries', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Agent$TagEntries', N'Tag', N'platformid', null, null, null, 1, null, null, null),
		(N'cat', N'AgentAddresses', N'Agent', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'AgentAddresses', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'AgentAddresses', N'RowNo', N'int', null, null, null, 1, null, null, null),
		(N'cat', N'AgentAddresses', N'Text', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Agents', N'Date', N'date', null, null, null, 1, null, null, null),
		(N'cat', N'Agents', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Agents', N'IsSystem', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Agents', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Agents', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Agents', N'Store', N'platformid', null, null, null, 1, N'cat', N'Stores', null),
		(N'cat', N'Agents', N'UserCreated', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Agents', N'UserModified', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Agents', N'UtcDateCreated', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'Agents', N'UtcDateModified', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'Agents', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Agents', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'cat', N'Items', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Items', N'IsSystem', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Items', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Items', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Items', N'Unit', N'platformid', null, null, null, 1, N'cat', N'Units', null),
		(N'cat', N'Items', N'UserCreated', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Items', N'UserModified', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Items', N'UtcDateCreated', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'Items', N'UtcDateModified', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'Items', N'VatRate', N'nvarchar', 64, null, null, 1, N'enm', N'VatRates', null),
		(N'cat', N'Items', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Items', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'cat', N'StoreAddresses', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'StoreAddresses', N'RowNo', N'int', null, null, null, 1, null, null, null),
		(N'cat', N'StoreAddresses', N'Store', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'StoreAddresses', N'Text', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Stores', N'Agent', N'platformid', null, null, null, 1, N'cat', N'Agents', null),
		(N'cat', N'Stores', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Stores', N'IsSystem', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Stores', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Stores', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Stores', N'UserCreated', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Stores', N'UserModified', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Stores', N'UtcDateCreated', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'Stores', N'UtcDateModified', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'Stores', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Stores', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'cat', N'Units', N'Denom', N'money', null, null, null, 1, null, null, null),
		(N'cat', N'Units', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'cat', N'Units', N'IsSystem', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Units', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Units', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'cat', N'Units', N'Short', N'nvarchar', 8, null, null, 1, null, null, null),
		(N'cat', N'Units', N'UserCreated', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Units', N'UserModified', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Units', N'UtcDateCreated', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'Units', N'UtcDateModified', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'cat', N'Units', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'cat', N'Units', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'doc', N'Autonum$Values', N'Autonum', N'nvarchar', 64, null, null, 1, null, null, null),
		(N'doc', N'Autonum$Values', N'CurrentNumber', N'int', null, null, null, 1, null, null, null),
		(N'doc', N'Autonum$Values', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'doc', N'Autonum$Values', N'Month', N'int', null, null, null, 1, null, null, null),
		(N'doc', N'Autonum$Values', N'Quart', N'int', null, null, null, 1, null, null, null),
		(N'doc', N'Autonum$Values', N'Year', N'int', null, null, null, 1, null, null, null),
		(N'doc', N'Autonums', N'Id', N'nvarchar', 64, null, null, 0, null, null, null),
		(N'doc', N'Autonums', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'doc', N'Autonums', N'Pattern', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'doc', N'Autonums', N'Period', N'nvarchar', 16, null, null, 1, null, null, null),
		(N'doc', N'DocumentRows', N'Document', N'platformid', null, null, null, 0, null, null, null),
		(N'doc', N'DocumentRows', N'Id', N'platformid', null, null, null, 0, null, null, null),
		(N'doc', N'DocumentRows', N'Item', N'platformid', null, null, null, 1, N'cat', N'Items', null),
		(N'doc', N'DocumentRows', N'Kind', N'nvarchar', 64, null, null, 1, null, null, null),
		(N'doc', N'DocumentRows', N'Price', N'decimal', null, 19, 6, 1, null, null, null),
		(N'doc', N'DocumentRows', N'Qty', N'decimal', null, 19, 6, 1, null, null, null),
		(N'doc', N'DocumentRows', N'RowNo', N'int', null, null, null, 1, null, null, null),
		(N'doc', N'DocumentRows', N'Sum', N'decimal', null, 19, 4, 1, null, null, null),
		(N'doc', N'DocumentRows', N'Unit', N'platformid', null, null, null, 1, N'cat', N'Units', null),
		(N'doc', N'DocumentRows', N'VatRate', N'nvarchar', 64, null, null, 1, N'enm', N'VatRates', null),
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
		(N'doc', N'StockDocuments', N'UserCreated', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'doc', N'StockDocuments', N'UserModified', N'bigint', null, null, null, 0, null, null, N'0'),
		(N'doc', N'StockDocuments', N'UserPosted', N'bigint', null, null, null, 1, null, null, null),
		(N'doc', N'StockDocuments', N'UtcDateCreated', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'doc', N'StockDocuments', N'UtcDateModified', N'datetime', null, null, null, 0, null, null, N'getutcdate()'),
		(N'doc', N'StockDocuments', N'UtcDatePosted', N'datetime', null, null, null, 1, null, null, null),
		(N'doc', N'StockDocuments', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
		(N'doc', N'StockDocuments', N'rv', N'timestamp', null, null, null, 0, null, null, null),
		(N'enm', N'VatRates', N'Id', N'nvarchar', 64, null, null, 0, null, null, null),
		(N'enm', N'VatRates', N'Memo', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'enm', N'VatRates', N'Name', N'nvarchar', 255, null, null, 1, null, null, null),
		(N'enm', N'VatRates', N'Order', N'int', null, null, null, 1, null, null, null),
		(N'enm', N'VatRates', N'Void', N'bit', null, null, null, 0, null, null, N'0'),
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
    when matched then update set
        t.[xtra] = s.[xtra],
        t.[master_schema] = s.[master_schema],
        t.[master_table] = s.[master_table],
        t.[master_column] = s.[master_column]
    when not matched then insert([schema], [table], [xtra],
        [master_schema], [master_table], [master_column]) values
       (s.[schema], s.[table], s.[xtra],
        s.[master_schema], s.[master_table], s.[master_column])
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
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'enm')
	exec sp_executesql N'create schema enm authorization dbo';
go
if not exists(select * from INFORMATION_SCHEMA.SCHEMATA where SCHEMA_NAME=N'jrn')
	exec sp_executesql N'create schema jrn authorization dbo';
go

grant select, insert, update, execute on schema::doc to public;
grant select, insert, update, execute on schema::cat to public;
grant select, insert, update, execute on schema::enm to public;
grant select, insert, update, execute on schema::jrn to public;
go

-- TABLES
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'doc' and SEQUENCE_NAME = N'SQ_Autonums')
	create sequence doc.[SQ_Autonums] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'doc' and TABLE_NAME=N'Autonums')
create table doc.[Autonums]
(
    [Id] nvarchar(64) not null,
    [Name] nvarchar(255),
    [Pattern] nvarchar(255),
    [Period] nvarchar(16),
    constraint PK_Autonums primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'doc' and SEQUENCE_NAME = N'SQ_Autonum$Values')
	create sequence doc.[SQ_Autonum$Values] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'doc' and TABLE_NAME=N'Autonum$Values')
create table doc.[Autonum$Values]
(
    [Id] platformid not null
       constraint DF_Autonum$Values_Id default(next value for doc.[SQ_Autonum$Values]),
    [Autonum] nvarchar(64),
    [Year] int,
    [Quart] int,
    [Month] int,
    [CurrentNumber] int,
    constraint PK_Autonum$Values primary key (Id)
);
go
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
    [UserCreated] bigint not null
       constraint DF_StockDocuments_UserCreated default(0),
    [UtcDateCreated] datetime not null
       constraint DF_StockDocuments_UtcDateCreated default(getutcdate()),
    [UserModified] bigint not null
       constraint DF_StockDocuments_UserModified default(0),
    [UtcDateModified] datetime not null
       constraint DF_StockDocuments_UtcDateModified default(getutcdate()),
    [UserPosted] bigint,
    [UtcDatePosted] datetime,
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
    [Document] platformid not null,
    [RowNo] int,
    [Kind] nvarchar(64),
    [Qty] decimal(19, 6),
    [Price] decimal(19, 6),
    [Sum] decimal(19, 4),
    [Item] platformid,
    [Unit] platformid,
    [VatRate] nvarchar(64),
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
    [UserCreated] bigint not null
       constraint DF_Agents_UserCreated default(0),
    [UtcDateCreated] datetime not null
       constraint DF_Agents_UtcDateCreated default(getutcdate()),
    [UserModified] bigint not null
       constraint DF_Agents_UserModified default(0),
    [UtcDateModified] datetime not null
       constraint DF_Agents_UtcDateModified default(getutcdate()),
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
    [Agent] platformid not null,
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
    [Agent] platformid not null,
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
    [UserCreated] bigint not null
       constraint DF_Items_UserCreated default(0),
    [UtcDateCreated] datetime not null
       constraint DF_Items_UtcDateCreated default(getutcdate()),
    [UserModified] bigint not null
       constraint DF_Items_UserModified default(0),
    [UtcDateModified] datetime not null
       constraint DF_Items_UtcDateModified default(getutcdate()),
    [Unit] platformid,
    [VatRate] nvarchar(64),
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
    [UserCreated] bigint not null
       constraint DF_Stores_UserCreated default(0),
    [UtcDateCreated] datetime not null
       constraint DF_Stores_UtcDateCreated default(getutcdate()),
    [UserModified] bigint not null
       constraint DF_Stores_UserModified default(0),
    [UtcDateModified] datetime not null
       constraint DF_Stores_UtcDateModified default(getutcdate()),
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
    [Store] platformid not null,
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
    [UserCreated] bigint not null
       constraint DF_Units_UserCreated default(0),
    [UtcDateCreated] datetime not null
       constraint DF_Units_UtcDateCreated default(getutcdate()),
    [UserModified] bigint not null
       constraint DF_Units_UserModified default(0),
    [UtcDateModified] datetime not null
       constraint DF_Units_UtcDateModified default(getutcdate()),
    [Short] nvarchar(8),
    [Denom] money,
    constraint PK_Units primary key (Id)
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'enm' and SEQUENCE_NAME = N'SQ_VatRates')
	create sequence enm.[SQ_VatRates] as bigint start with 1000 increment by 1;

if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'enm' and TABLE_NAME=N'VatRates')
create table enm.[VatRates]
(
    [Id] nvarchar(64) not null,
    [Void] bit not null
       constraint DF_VatRates_Void default(0),
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Order] int,
    constraint PK_VatRates primary key (Id)
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
    [UserCreated] bigint not null
       constraint DF_$Tags_UserCreated default(0),
    [UtcDateCreated] datetime not null
       constraint DF_$Tags_UtcDateCreated default(getutcdate()),
    [UserModified] bigint not null
       constraint DF_$Tags_UserModified default(0),
    [UtcDateModified] datetime not null
       constraint DF_$Tags_UtcDateModified default(getutcdate()),
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
drop type if exists doc.[Autonum.Meta.TableType];
create type doc.[Autonum.Meta.TableType] as table
(
    [Id] nvarchar(64),
    [Name] nvarchar(255),
    [Pattern] nvarchar(255),
    [Period] nvarchar(16)
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
    [Document] platformid,
    [RowNo] int,
    [Kind] nvarchar(64),
    [Qty] decimal(19, 6),
    [Price] decimal(19, 6),
    [Sum] decimal(19, 4),
    [Item] platformid,
    [Unit] platformid,
    [VatRate] nvarchar(64)
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
    [Agent] platformid,
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
    [Unit] platformid,
    [VatRate] nvarchar(64)
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
    [Store] platformid,
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
drop type if exists enm.[VatRate.Meta.TableType];
create type enm.[VatRate.Meta.TableType] as table
(
    [Id] nvarchar(64),
    [Void] bit,
    [Name] nvarchar(255),
    [Memo] nvarchar(255),
    [Order] int
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

-- ENUM VALUES
------------------------------------------------
begin
    set nocount on;
    declare @VatRate table([Id] nvarchar(64), [Name] nvarchar(255), [Memo] nvarchar(255),
        [Order] int, [Void] bit);

    insert into @VatRate([Id], [Name], [Memo], [Order], [Void]) values
	(N'', N'@[VatRate.All]', null, -1, 0),
	(N'20', N'20%', null, 0, 0),
	(N'7', N'7%', null, 1, 0),
	(N'14', N'14%', null, 2, 0),
	(N'901', N'0% (901)', null, 3, 0),
	(N'902', N'0% (902)', null, 4, 0),
	(N'903', N'Без ПДВ (903)', null, 5, 0);

    merge enm.[VatRates] as t
    using @VatRate as s
    on t.[Id] = s.[Id]
    when matched then update set
        t.[Name] = s.[Name],
        t.[Memo] = s.[Memo],
        t.[Order] = s.[Order],
        t.[Void] = s.[Void]
    when not matched then insert ([Id], [Name], [Memo], [Order], [Void]) values
        (s.[Id], s.[Name], s.[Memo], s.[Order], s.[Void])
    when not matched by source then update set
        t.[Void] = 1;
end
go

-- AUTONUMS
------------------------------------------------
begin
    set nocount on;
    declare @Autonum table([Id] nvarchar(64), [Name] nvarchar(255),
        [Pattern] nvarchar(255), [Period] nvarchar(16));

    insert into @Autonum([Id], [Name], [Pattern], [Period]) values
	(N'waybill', N'@[Autonum.waybill]', N'Н-{yyyy}/{nnnnn}', N'Year');

    merge doc.[Autonums] as t
    using @Autonum as s
    on t.[Id] = s.[Id]
    when matched then update set
        t.[Name] = s.[Name],
        t.[Pattern] = s.[Pattern],
        t.[Period] = s.[Period]
    when not matched then insert ([Id], [Name], [Pattern], [Period]) values
        (s.[Id], s.[Name], s.[Pattern], s.[Period]);
end
go

-- AUTONUM
------------------------------------------------
create or alter procedure doc.[Autonum.NextValue]
@Autonum nvarchar(64),
@Date date,
@Number nvarchar(64) output
as
begin
    set nocount on;
    set transaction isolation level read committed;

    declare @pattern nvarchar(255), @y int, @q int, @m int;

    select @pattern = [Pattern],
        @y = case when [Period] <> N'None' then year(@Date) else 0 end,
        @q = case when [Period] = N'Quarter' then datepart(quarter, @Date) else 0 end,
        @m = case when [Period] = N'Month' then month(@Date) else 0 end
    from doc.[Autonums] where [Id] = @Autonum;

    /* Not a 'UI:' message: nothing here is the user's to fix, and the load refuses a
     * numbering that is not declared (CheckAutonumDeclaredAsync), so what is left to reach
     * this is a database behind its own metadata. That reader needs the key and the table,
     * which is exactly what a localized string cannot carry.
     */
    if @pattern is null
    begin
        declare @msg nvarchar(255) = concat(N'Autonum ''', @Autonum, N''' is not found in doc.[Autonums]. Redeploy the database');
        throw 60000, @msg, 0;
    end

    /* One statement, and 'holdlock' is what makes it one: update-then-insert lets two
     * callers both find no row for a period that has just begun and both insert one - a
     * counter split in two, and from then on every number issued twice. The lock is taken
     * over the table's unique index, so it is on that one key and not on a range of them.
     */
    declare @rtable table(number int);
    merge into doc.[Autonum$Values] with (holdlock) as t
    using (select @Autonum, @y, @q, @m) as s([Autonum], [Year], [Quart], [Month])
        on t.[Autonum] = s.[Autonum] and t.[Year] = s.[Year]
            and t.[Quart] = s.[Quart] and t.[Month] = s.[Month]
    when matched then update set t.[CurrentNumber] = t.[CurrentNumber] + 1
    when not matched then insert ([Autonum], [Year], [Quart], [Month], [CurrentNumber])
        values (s.[Autonum], s.[Year], s.[Quart], s.[Month], 1)
    output inserted.[CurrentNumber] into @rtable(number);

    declare @n int;
    select @n = number from @rtable;

    set @Number = replace(@pattern, N'{yyyy}', format(@Date, N'yyyy'));
    set @Number = replace(@Number, N'{yy}', format(@Date, N'yy'));
    set @Number = replace(@Number, N'{mm}', format(@Date, N'MM'));
    set @Number = replace(@Number, N'{qq}', format(datepart(quarter, @Date), N'00'));

    -- the counter's own token carries its width: '{nnnnn}' is five digits, zero padded
    declare @p0 int, @p1 int;
    set @p0 = charindex(N'{n', @Number);
    set @p1 = charindex(N'n}', @Number);
    set @Number = stuff(@Number, @p0, @p1 - @p0 + 2, format(@n, replicate(N'0', @p1 - @p0)));
end
go

-- SYSTEM USER
if not exists(select * from a2security.Users where Id = 0)
    insert into a2security.Users(Id, UserName, SecurityStamp) values (0, N'System', N'');
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
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_UserCreated_Users')
    alter table doc.[StockDocuments] add
        constraint FK_StockDocuments_UserCreated_Users foreign key ([UserCreated]) references a2security.Users([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_UserModified_Users')
    alter table doc.[StockDocuments] add
        constraint FK_StockDocuments_UserModified_Users foreign key ([UserModified]) references a2security.Users([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_UserPosted_Users')
    alter table doc.[StockDocuments] add
        constraint FK_StockDocuments_UserPosted_Users foreign key ([UserPosted]) references a2security.Users([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'DocumentRows' and CONSTRAINT_NAME = N'FK_DocumentRows_Document_StockDocuments')
    alter table doc.[DocumentRows] add
        constraint FK_DocumentRows_Document_StockDocuments foreign key ([Document]) references doc.[StockDocuments]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'DocumentRows' and CONSTRAINT_NAME = N'FK_DocumentRows_Item_Items')
    alter table doc.[DocumentRows] add
        constraint FK_DocumentRows_Item_Items foreign key ([Item]) references cat.[Items]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'DocumentRows' and CONSTRAINT_NAME = N'FK_DocumentRows_Unit_Units')
    alter table doc.[DocumentRows] add
        constraint FK_DocumentRows_Unit_Units foreign key ([Unit]) references cat.[Units]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'DocumentRows' and CONSTRAINT_NAME = N'FK_DocumentRows_VatRate_VatRates')
    alter table doc.[DocumentRows] add
        constraint FK_DocumentRows_VatRate_VatRates foreign key ([VatRate]) references enm.[VatRates]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Agents' and CONSTRAINT_NAME = N'FK_Agents_Store_Stores')
    alter table cat.[Agents] add
        constraint FK_Agents_Store_Stores foreign key ([Store]) references cat.[Stores]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Agents' and CONSTRAINT_NAME = N'FK_Agents_UserCreated_Users')
    alter table cat.[Agents] add
        constraint FK_Agents_UserCreated_Users foreign key ([UserCreated]) references a2security.Users([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Agents' and CONSTRAINT_NAME = N'FK_Agents_UserModified_Users')
    alter table cat.[Agents] add
        constraint FK_Agents_UserModified_Users foreign key ([UserModified]) references a2security.Users([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Agent$TagEntries' and CONSTRAINT_NAME = N'FK_Agent$TagEntries_Agent_Agents')
    alter table cat.[Agent$TagEntries] add
        constraint FK_Agent$TagEntries_Agent_Agents foreign key ([Agent]) references cat.[Agents]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Agent$TagEntries' and CONSTRAINT_NAME = N'FK_Agent$TagEntries_Tag_$Tags')
    alter table cat.[Agent$TagEntries] add
        constraint FK_Agent$TagEntries_Tag_$Tags foreign key ([Tag]) references cat.[$Tags]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'AgentAddresses' and CONSTRAINT_NAME = N'FK_AgentAddresses_Agent_Agents')
    alter table cat.[AgentAddresses] add
        constraint FK_AgentAddresses_Agent_Agents foreign key ([Agent]) references cat.[Agents]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Items' and CONSTRAINT_NAME = N'FK_Items_Unit_Units')
    alter table cat.[Items] add
        constraint FK_Items_Unit_Units foreign key ([Unit]) references cat.[Units]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Items' and CONSTRAINT_NAME = N'FK_Items_VatRate_VatRates')
    alter table cat.[Items] add
        constraint FK_Items_VatRate_VatRates foreign key ([VatRate]) references enm.[VatRates]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Items' and CONSTRAINT_NAME = N'FK_Items_UserCreated_Users')
    alter table cat.[Items] add
        constraint FK_Items_UserCreated_Users foreign key ([UserCreated]) references a2security.Users([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Items' and CONSTRAINT_NAME = N'FK_Items_UserModified_Users')
    alter table cat.[Items] add
        constraint FK_Items_UserModified_Users foreign key ([UserModified]) references a2security.Users([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Stores' and CONSTRAINT_NAME = N'FK_Stores_Agent_Agents')
    alter table cat.[Stores] add
        constraint FK_Stores_Agent_Agents foreign key ([Agent]) references cat.[Agents]([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Stores' and CONSTRAINT_NAME = N'FK_Stores_UserCreated_Users')
    alter table cat.[Stores] add
        constraint FK_Stores_UserCreated_Users foreign key ([UserCreated]) references a2security.Users([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Stores' and CONSTRAINT_NAME = N'FK_Stores_UserModified_Users')
    alter table cat.[Stores] add
        constraint FK_Stores_UserModified_Users foreign key ([UserModified]) references a2security.Users([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'StoreAddresses' and CONSTRAINT_NAME = N'FK_StoreAddresses_Store_Stores')
    alter table cat.[StoreAddresses] add
        constraint FK_StoreAddresses_Store_Stores foreign key ([Store]) references cat.[Stores]([Id]);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Units' and CONSTRAINT_NAME = N'FK_Units_UserCreated_Users')
    alter table cat.[Units] add
        constraint FK_Units_UserCreated_Users foreign key ([UserCreated]) references a2security.Users([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Units' and CONSTRAINT_NAME = N'FK_Units_UserModified_Users')
    alter table cat.[Units] add
        constraint FK_Units_UserModified_Users foreign key ([UserModified]) references a2security.Users([Id]);
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
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'$Tags' and CONSTRAINT_NAME = N'FK_$Tags_UserCreated_Users')
    alter table cat.[$Tags] add
        constraint FK_$Tags_UserCreated_Users foreign key ([UserCreated]) references a2security.Users([Id]);
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'$Tags' and CONSTRAINT_NAME = N'FK_$Tags_UserModified_Users')
    alter table cat.[$Tags] add
        constraint FK_$Tags_UserModified_Users foreign key ([UserModified]) references a2security.Users([Id]);
go

-- INDEXES
------------------------------------------------
if not exists(select * from sys.indexes where object_id = object_id(N'doc.[Autonum$Values]') and name = N'UX_Autonum$Values_Autonum_Year_Quart_Month')
    create unique index UX_Autonum$Values_Autonum_Year_Quart_Month on doc.[Autonum$Values] ([Autonum], [Year], [Quart], [Month]);
go

