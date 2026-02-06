-- TABLES
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Items')
	create sequence cat.[SQ_Items] as bigint start with 1000 increment by 1;
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Items')
create table cat.[Items]
(
    [Id] bigint not null
       constraint DF_Items_Id default(next value for cat.[SQ_Items]),
    [Void] bit not null
       constraint DF_Items_Void default(0),
    [IsSystem] bit not null
       constraint DF_Items_IsSystem default(0),
    [rv] rowversion,
    [Name] nvarchar(100),
    [Unit] bigint,
    [VatRate] nvarchar(16),
    [Memo] nvarchar(255),
    constraint PK_Items primary key ([Id])
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'doc' and SEQUENCE_NAME = N'SQ_StockDocuments')
	create sequence doc.[SQ_StockDocuments] as bigint start with 1000 increment by 1;
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'doc' and TABLE_NAME=N'StockDocuments')
create table doc.[StockDocuments]
(
    [Id] bigint not null
       constraint DF_StockDocuments_Id default(next value for doc.[SQ_StockDocuments]),
    [Void] bit not null
       constraint DF_StockDocuments_Void default(0),
    [Done] bit not null
       constraint DF_StockDocuments_Done default(0),
    [Date] date,
    [Number] nvarchar(32),
    [Operation] nvarchar(64),
    [Name] nvarchar(100),
    [Sum] money,
    [Memo] nvarchar(255),
    [Agent] bigint,
    [StoreFrom] bigint,
    [StoreTo] bigint,
    constraint PK_StockDocuments primary key ([Id])
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'doc' and SEQUENCE_NAME = N'SQ_RvDocuments')
	create sequence doc.[SQ_RvDocuments] as bigint start with 1000 increment by 1;
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'doc' and TABLE_NAME=N'RvDocuments')
create table doc.[RvDocuments]
(
    [Id] bigint not null
       constraint DF_RvDocuments_Id default(next value for doc.[SQ_RvDocuments]),
    [Void] bit not null
       constraint DF_RvDocuments_Void default(0),
    [Done] bit not null
       constraint DF_RvDocuments_Done default(0),
    [rv] rowversion,
    [Date] date,
    [Number] nvarchar(32),
    [Operation] nvarchar(64),
    [Name] nvarchar(100),
    [Sum] money,
    [Memo] nvarchar(255),
    constraint PK_RvDocuments primary key ([Id])
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'doc' and SEQUENCE_NAME = N'SQ_Rows')
	create sequence doc.[SQ_Rows] as bigint start with 1000 increment by 1;
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'doc' and TABLE_NAME=N'Rows')
create table doc.[Rows]
(
    [Id] bigint not null
       constraint DF_Rows_Id default(next value for doc.[SQ_Rows]),
    [Parent] bigint,
    [RowNo] int,
    [Kind] nvarchar(32),
    [Item] bigint,
    [VatRate] nvarchar(16),
    [Qty] float,
    [Price] float,
    [Sum] money,
    constraint PK_Rows primary key ([Id])
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Stores')
	create sequence cat.[SQ_Stores] as bigint start with 1000 increment by 1;
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Stores')
create table cat.[Stores]
(
    [Id] bigint not null
       constraint DF_Stores_Id default(next value for cat.[SQ_Stores]),
    [Void] bit not null
       constraint DF_Stores_Void default(0),
    [IsSystem] bit not null
       constraint DF_Stores_IsSystem default(0),
    [rv] rowversion,
    [Name] nvarchar(100),
    [Memo] nvarchar(255),
    [IsFolder] bit not null
       constraint DF_Stores_IsFolder default(0),
    [Parent] bigint,
    constraint PK_Stores primary key ([Id])
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Addresses')
	create sequence cat.[SQ_Addresses] as bigint start with 1000 increment by 1;
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Addresses')
create table cat.[Addresses]
(
    [Id] bigint not null
       constraint DF_Addresses_Id default(next value for cat.[SQ_Addresses]),
    [Parent] bigint,
    [RowNo] int,
    [Text] nvarchar(50),
    constraint PK_Addresses primary key ([Id])
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Units')
	create sequence cat.[SQ_Units] as bigint start with 1000 increment by 1;
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Units')
create table cat.[Units]
(
    [Id] bigint not null
       constraint DF_Units_Id default(next value for cat.[SQ_Units]),
    [Void] bit not null
       constraint DF_Units_Void default(0),
    [IsSystem] bit not null
       constraint DF_Units_IsSystem default(0),
    [rv] rowversion,
    [Name] nvarchar(100),
    [Short] nvarchar(50),
    [Memo] nvarchar(255),
    [Denom] decimal(10,5),
    constraint PK_Units primary key ([Id])
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.SEQUENCES where SEQUENCE_SCHEMA = N'cat' and SEQUENCE_NAME = N'SQ_Agents')
	create sequence cat.[SQ_Agents] as bigint start with 1000 increment by 1;
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'cat' and TABLE_NAME=N'Agents')
create table cat.[Agents]
(
    [Id] bigint not null
       constraint DF_Agents_Id default(next value for cat.[SQ_Agents]),
    [Void] bit not null
       constraint DF_Agents_Void default(0),
    [IsSystem] bit not null
       constraint DF_Agents_IsSystem default(0),
    [Name] nvarchar(100),
    [Date] date,
    [Memo] nvarchar(255),
    [Store] bigint,
    constraint PK_Agents primary key ([Id])
);
go

------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'jrn' and TABLE_NAME=N'StockJournal')
create table jrn.[StockJournal]
(
    [Id] bigint not null,
    [Date] datetime,
    [InOut] int not null,
    [Qty] float,
    [Sum] money not null,
    [Document] bigint,
    [Operation] nvarchar(64),
    [Store] bigint,
    [Agent] bigint,
    [Item] bigint,
    constraint PK_StockJournal primary key ([Id],[InOut],[Sum])
);
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'enm' and TABLE_NAME=N'VatRates')
create table enm.[VatRates]
(
    [Id] nvarchar(16) not null
        constraint PK_VatRates primary key,
    [Name] nvarchar(255),
    [Order] int not null,
    Inactive bit not null
        constraint DF_VatRates_Inactive default(0)
);
go
