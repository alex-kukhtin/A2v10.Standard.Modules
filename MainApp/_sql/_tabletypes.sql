-- TABLE TYPES
------------------------------------------------
drop type if exists cat.[Items.TableType];
create type cat.[Items.TableType] as table
(
    [Id] bigint,
    [Void] bit,
    [IsSystem] bit,
    [rv] varbinary(8),
    [Name] nvarchar(100),
    [Unit] bigint,
    [VatRate] nvarchar(16),
    [Memo] nvarchar(255)
);
go
------------------------------------------------
drop type if exists doc.[StockDocuments.TableType];
create type doc.[StockDocuments.TableType] as table
(
    [Id] bigint,
    [Void] bit,
    [Done] bit,
    [Date] date,
    [Number] nvarchar(32),
    [Operation] nvarchar(64),
    [Name] nvarchar(100),
    [Sum] money,
    [Memo] nvarchar(255),
    [Agent] bigint,
    [StoreFrom] bigint,
    [StoreTo] bigint
);
go
------------------------------------------------
drop type if exists doc.[RvDocuments.TableType];
create type doc.[RvDocuments.TableType] as table
(
    [Id] bigint,
    [Void] bit,
    [Done] bit,
    [rv] varbinary(8),
    [Date] date,
    [Number] nvarchar(32),
    [Operation] nvarchar(64),
    [Name] nvarchar(100),
    [Sum] money,
    [Memo] nvarchar(255)
);
go
------------------------------------------------
drop type if exists doc.[Rows.TableType];
create type doc.[Rows.TableType] as table
(
    [Id] bigint,
    [Parent] bigint,
    [RowNo] int,
    [Kind] nvarchar(32),
    [Item] bigint,
    [VatRate] nvarchar(16),
    [Qty] float,
    [Price] float,
    [Sum] money
);
go
------------------------------------------------
drop type if exists cat.[Stores.TableType];
create type cat.[Stores.TableType] as table
(
    [Id] bigint,
    [Void] bit,
    [IsSystem] bit,
    [rv] varbinary(8),
    [Name] nvarchar(100),
    [Memo] nvarchar(255),
    [IsFolder] bit,
    [Parent] bigint
);
go
------------------------------------------------
drop type if exists cat.[Addresses.TableType];
create type cat.[Addresses.TableType] as table
(
    [Id] bigint,
    [Parent] bigint,
    [RowNo] int,
    [Text] nvarchar(50)
);
go
------------------------------------------------
drop type if exists cat.[Units.TableType];
create type cat.[Units.TableType] as table
(
    [Id] bigint,
    [Void] bit,
    [IsSystem] bit,
    [rv] varbinary(8),
    [Name] nvarchar(100),
    [Short] nvarchar(50),
    [Memo] nvarchar(255),
    [Denom] decimal(10,5)
);
go
------------------------------------------------
drop type if exists cat.[Agents.TableType];
create type cat.[Agents.TableType] as table
(
    [Id] bigint,
    [Void] bit,
    [IsSystem] bit,
    [Name] nvarchar(100),
    [Date] date,
    [Memo] nvarchar(255),
    [Store] bigint
);
go
------------------------------------------------
drop type if exists jrn.[StockJournal.TableType];
create type jrn.[StockJournal.TableType] as table
(
    [Id] bigint,
    [Date] datetime,
    [InOut] int,
    [Qty] float,
    [Sum] money,
    [Document] bigint,
    [Operation] nvarchar(64),
    [Store] bigint,
    [Agent] bigint,
    [Item] bigint
);
go
