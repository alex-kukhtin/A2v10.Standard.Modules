/* Client */
------------------------------------------------
create or alter procedure cat.[TestPDF.Load]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;


	select [TestObject!TTestObject!Object] = null, [Id!!Id] = 1;
end
go
------------------------------------------------
create or alter procedure cat.[TestPDF.Model.Report]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;
	
	select [Agents!TAgent!Array] = null, Id, [Name], Memo
	from cat.Agents;
end
go

--create table dbo.Orders(Id bigint, InstanceId uniqueidentifier, [State] nvarchar(255));

------------------------------------------------
create or alter procedure a2wf.[TestProcess.Order.SetInstanceId]
@Id bigint,
@InstanceId uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read committed;

	insert into dbo.Orders(Id, InstanceId, [State]) values (@Id, @InstanceId, N'Draft');
end
go
------------------------------------------------
create or alter procedure a2wf.[TestProcess.Order.LoadPersistent]
@Id bigint
as
begin
	set nocount on;
	set transaction isolation level read committed;

	select [Order!TOrder!Object] = null, [Id!!Id] = Id, [State] 
	from dbo.Orders where Id = @Id;
end
go
------------------------------------------------
create or alter procedure a2wf.[TestProcess.Order.SavePersistent]
@Id bigint,
@State nvarchar(255)
as
begin
	set nocount on;
	set transaction isolation level read committed;

	update dbo.Orders set [State] = @State
	where Id = @Id;
end
go