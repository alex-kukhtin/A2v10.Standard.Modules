-- FOREIGN KEYS
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Items' and CONSTRAINT_NAME = N'FK_Items_Unit_Units')
    alter table cat.[Items] add 
        constraint FK_Items_Unit_Units foreign key ([Unit]) references cat.[Units]([Id]);

alter table cat.[Items] nocheck constraint FK_Items_Unit_Units;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Items' and CONSTRAINT_NAME = N'FK_Items_VatRate_VatRates')
    alter table cat.[Items] add 
        constraint FK_Items_VatRate_VatRates foreign key ([VatRate]) references enm.[VatRates]([Id]);

alter table cat.[Items] nocheck constraint FK_Items_VatRate_VatRates;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_Operation_Operations')
    alter table doc.[StockDocuments] add 
        constraint FK_StockDocuments_Operation_Operations foreign key ([Operation]) references op.[Operations]([Id]);

alter table doc.[StockDocuments] nocheck constraint FK_StockDocuments_Operation_Operations;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_Agent_Agents')
    alter table doc.[StockDocuments] add 
        constraint FK_StockDocuments_Agent_Agents foreign key ([Agent]) references cat.[Agents]([Id]);

alter table doc.[StockDocuments] nocheck constraint FK_StockDocuments_Agent_Agents;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_StoreFrom_Stores')
    alter table doc.[StockDocuments] add 
        constraint FK_StockDocuments_StoreFrom_Stores foreign key ([StoreFrom]) references cat.[Stores]([Id]);

alter table doc.[StockDocuments] nocheck constraint FK_StockDocuments_StoreFrom_Stores;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'StockDocuments' and CONSTRAINT_NAME = N'FK_StockDocuments_StoreTo_Stores')
    alter table doc.[StockDocuments] add 
        constraint FK_StockDocuments_StoreTo_Stores foreign key ([StoreTo]) references cat.[Stores]([Id]);

alter table doc.[StockDocuments] nocheck constraint FK_StockDocuments_StoreTo_Stores;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'RvDocuments' and CONSTRAINT_NAME = N'FK_RvDocuments_Operation_Operations')
    alter table doc.[RvDocuments] add 
        constraint FK_RvDocuments_Operation_Operations foreign key ([Operation]) references op.[Operations]([Id]);

alter table doc.[RvDocuments] nocheck constraint FK_RvDocuments_Operation_Operations;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'Rows' and CONSTRAINT_NAME = N'FK_Rows_Parent_StockDocuments')
    alter table doc.[Rows] add 
        constraint FK_Rows_Parent_StockDocuments foreign key ([Parent]) references doc.[StockDocuments]([Id]);

alter table doc.[Rows] nocheck constraint FK_Rows_Parent_StockDocuments;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'Rows' and CONSTRAINT_NAME = N'FK_Rows_Item_Items')
    alter table doc.[Rows] add 
        constraint FK_Rows_Item_Items foreign key ([Item]) references cat.[Items]([Id]);

alter table doc.[Rows] nocheck constraint FK_Rows_Item_Items;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'doc' and TABLE_NAME = N'Rows' and CONSTRAINT_NAME = N'FK_Rows_VatRate_VatRates')
    alter table doc.[Rows] add 
        constraint FK_Rows_VatRate_VatRates foreign key ([VatRate]) references enm.[VatRates]([Id]);

alter table doc.[Rows] nocheck constraint FK_Rows_VatRate_VatRates;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Stores' and CONSTRAINT_NAME = N'FK_Stores_Parent_Stores')
    alter table cat.[Stores] add 
        constraint FK_Stores_Parent_Stores foreign key ([Parent]) references cat.[Stores]([Id]);

alter table cat.[Stores] nocheck constraint FK_Stores_Parent_Stores;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Addresses' and CONSTRAINT_NAME = N'FK_Addresses_Parent_Stores')
    alter table cat.[Addresses] add 
        constraint FK_Addresses_Parent_Stores foreign key ([Parent]) references cat.[Stores]([Id]);

alter table cat.[Addresses] nocheck constraint FK_Addresses_Parent_Stores;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'cat' and TABLE_NAME = N'Agents' and CONSTRAINT_NAME = N'FK_Agents_Store_Stores')
    alter table cat.[Agents] add 
        constraint FK_Agents_Store_Stores foreign key ([Store]) references cat.[Stores]([Id]);

alter table cat.[Agents] nocheck constraint FK_Agents_Store_Stores;
go
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Document_StockDocuments')
    alter table jrn.[StockJournal] add 
        constraint FK_StockJournal_Document_StockDocuments foreign key ([Document]) references doc.[StockDocuments]([Id]);

alter table jrn.[StockJournal] nocheck constraint FK_StockJournal_Document_StockDocuments;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Operation_Operations')
    alter table jrn.[StockJournal] add 
        constraint FK_StockJournal_Operation_Operations foreign key ([Operation]) references op.[Operations]([Id]);

alter table jrn.[StockJournal] nocheck constraint FK_StockJournal_Operation_Operations;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Store_Stores')
    alter table jrn.[StockJournal] add 
        constraint FK_StockJournal_Store_Stores foreign key ([Store]) references cat.[Stores]([Id]);

alter table jrn.[StockJournal] nocheck constraint FK_StockJournal_Store_Stores;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Agent_Agents')
    alter table jrn.[StockJournal] add 
        constraint FK_StockJournal_Agent_Agents foreign key ([Agent]) references cat.[Agents]([Id]);

alter table jrn.[StockJournal] nocheck constraint FK_StockJournal_Agent_Agents;
if not exists(select * from INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE where TABLE_SCHEMA = N'jrn' and TABLE_NAME = N'StockJournal' and CONSTRAINT_NAME = N'FK_StockJournal_Item_Items')
    alter table jrn.[StockJournal] add 
        constraint FK_StockJournal_Item_Items foreign key ([Item]) references cat.[Items]([Id]);

alter table jrn.[StockJournal] nocheck constraint FK_StockJournal_Item_Items;
go
