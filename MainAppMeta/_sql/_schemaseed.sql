begin
    declare @tables table([schema] sysname, [table] sysname);
    declare @columns table([schema] sysname, [table] sysname, [column] sysname, [datatype] sysname);
    
    insert into @tables([schema], [table]) values
    	('doc', 'StockDocuments'),
		('doc', 'Rows'),
		('cat', 'Agents'),
		('cat', 'Addresses'),
		('cat', 'Items'),
		('cat', 'Stores'),
		('cat', 'Addresses'),
		('cat', 'Units'),
		('jrn', 'StockJournal');

    insert into @columns([schema], [table], [column], [datatype]) values
    	('doc', 'StockDocuments', 'Id', 'platformid'),
		('doc', 'StockDocuments', 'Void', 'bit'),
		('doc', 'StockDocuments', 'Done', 'bit'),
		('doc', 'StockDocuments', 'Date', 'date'),
		('doc', 'StockDocuments', 'rv', 'timestamp'),
		('doc', 'StockDocuments', 'Memo', 'nvarchar'),
		('doc', 'StockDocuments', 'Number', 'nvarchar'),
		('doc', 'StockDocuments', 'Operation', 'nvarchar'),
		('doc', 'StockDocuments', 'StoreFrom', 'platformid'),
		('doc', 'StockDocuments', 'StoreTo', 'platformid'),
		('doc', 'StockDocuments', 'Agent', 'platformid'),
		('doc', 'Rows', 'Kind', 'nvarchar'),
		('doc', 'Rows', 'Qty', 'float'),
		('doc', 'Rows', 'Price', 'money'),
		('doc', 'Rows', 'Sum', 'money'),
		('doc', 'Rows', 'Item', 'platformid'),
		('doc', 'Rows', 'Unit', 'platformid'),
		('cat', 'Agents', 'Id', 'platformid'),
		('cat', 'Agents', 'Void', 'bit'),
		('cat', 'Agents', 'IsSystem', 'bit'),
		('cat', 'Agents', 'rv', 'timestamp'),
		('cat', 'Agents', 'Name', 'nvarchar'),
		('cat', 'Agents', 'Memo', 'nvarchar'),
		('cat', 'Agents', 'Date', 'date'),
		('cat', 'Agents', 'Store', 'platformid'),
		('cat', 'Addresses', 'Text', 'nvarchar'),
		('cat', 'Items', 'Id', 'platformid'),
		('cat', 'Items', 'Void', 'bit'),
		('cat', 'Items', 'IsSystem', 'bit'),
		('cat', 'Items', 'rv', 'timestamp'),
		('cat', 'Items', 'Name', 'nvarchar'),
		('cat', 'Items', 'Memo', 'nvarchar'),
		('cat', 'Items', 'Unit', 'platformid'),
		('cat', 'Stores', 'Id', 'platformid'),
		('cat', 'Stores', 'Void', 'bit'),
		('cat', 'Stores', 'IsSystem', 'bit'),
		('cat', 'Stores', 'rv', 'timestamp'),
		('cat', 'Stores', 'Name', 'nvarchar'),
		('cat', 'Stores', 'Memo', 'nvarchar'),
		('cat', 'Addresses', 'Text', 'nvarchar'),
		('cat', 'Units', 'Id', 'platformid'),
		('cat', 'Units', 'Void', 'bit'),
		('cat', 'Units', 'IsSystem', 'bit'),
		('cat', 'Units', 'rv', 'timestamp'),
		('cat', 'Units', 'Name', 'nvarchar'),
		('cat', 'Units', 'Memo', 'nvarchar'),
		('cat', 'Units', 'Short', 'nvarchar'),
		('cat', 'Units', 'Denom', 'money'),
		('jrn', 'StockJournal', 'Id', 'platformid'),
		('jrn', 'StockJournal', 'Date', 'date'),
		('jrn', 'StockJournal', 'InOut', 'smallint'),
		('jrn', 'StockJournal', 'Document', 'platformid'),
		('jrn', 'StockJournal', 'Operation', 'nvarchar'),
		('jrn', 'StockJournal', 'Detail', 'platformid'),
		('jrn', 'StockJournal', 'Qty', 'float'),
		('jrn', 'StockJournal', 'Sum', 'money'),
		('jrn', 'StockJournal', 'Store', 'platformid'),
		('jrn', 'StockJournal', 'Agent', 'platformid'),
		('jrn', 'StockJournal', 'Item', 'platformid');

    -- merge tables
    merge a2meta.Tables as t
    using @tables as s
    on t.[schema] = s.[schema] and t.[table] = s.[table]
    when not matched then insert([schema], [table]) values
       (s.[schema], s.[table])
    when not matched then delete;

    -- merge columns
    merge a2meta.Columns as t
    using @columns as s
    on t.[schema] = s.[schema] and t.[table] = s.[table] and t.[column] = s.[column]
    when matched then update
        t.[datatype] = s.[datatype]
    when not matched then insert
        ([schema], [table], [column], [datatype]) values
        (s.[schema], s.[table], s.[column], s.[datatype])
    when not matched then delete;
end
go