------------------------------------------------
begin
	set nocount on;

	declare @moduleId uniqueidentifier = N'BC9B0145-1698-4ED6-9446-63E673430D9F';

	exec a2ui.RegisterModule @ModuleId = @moduleId, @Name = N'Main'
	exec a2ui.[Tenant.ConnectModule] @ModuleId = @moduleId, @TenantId = 1;

	-- global
	exec a2ui.RegisterInitProcedure @Module = @moduleId, @Procedure = N'a2ui.[Menu.Main.Create]';

	declare @title nvarchar(255) = N'A2v10 Standard Modules'
	if not exists(select * from a2sys.SysParams where [Name] = N'AppTitle')
		insert into a2sys.SysParams ([Name], StringValue) values (N'AppTitle', @title);
	else
		update a2sys.SysParams set StringValue = @title where [Name] = N'AppTitle';
end
go

------------------------------------------------
create or alter procedure a2ui.[Menu.Main.Create]
@TenantId int = 1,
@ModuleId uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @menu a2ui.[Menu.TableType];

	--select newid(), newid(), newid()

	insert into @menu(Id, Parent, [Order], [Name], [Url], CreateName, CreateUrl, Icon, ClassName) 
	values
	(N'00000000-0000-0000-0000-000000000000', null,  
		0, N'Main', null, null, null, null, null),
	(N'4A39BAC4-B35C-47D7-901A-CF775AA6CB6F', N'00000000-0000-0000-0000-000000000000',  
		100, N'General', null, null, null,  N'grid', null),

	(N'6632D12B-326F-4EFF-81BC-82A6A78EDE82', N'4A39BAC4-B35C-47D7-901A-CF775AA6CB6F',
		20, N'@[WfAdm.BProcesses]',     null, null, null, null, null),
	(N'461AD415-956E-4885-94BF-D629E7501412', N'4A39BAC4-B35C-47D7-901A-CF775AA6CB6F',
		20, N'@[Adm.Administrator]',     null, null, null, null, null),

	-- Business Processes
	(N'4B78939D-986C-4B50-81F9-61407B7B6968', N'6632D12B-326F-4EFF-81BC-82A6A78EDE82', 
		10, N'@[WfAdm.Catalog]',   N'page:/$workflow/catalog/index/0', null, null, null, null),
	(N'B1EF5C47-6606-46DF-B75C-8258275FEBA4', N'6632D12B-326F-4EFF-81BC-82A6A78EDE82', 
		20, N'@[WfAdm.Instances]',   N'page:/$workflow/instance/index/0', null, null, null, null),
	(N'DBAD2EF1-476D-4869-8D13-E82959F0F331', N'6632D12B-326F-4EFF-81BC-82A6A78EDE82', 
		30, N'@[WfAdm.Autostart]',   N'page:/$workflow/autostart/index/0', null, null, null, null),
	-- Administrator
	(N'A0DDA379-7346-4558-88AC-CC5AAB5A25F4', N'461AD415-956E-4885-94BF-D629E7501412', 
		10, N'@[Adm.Users]',   N'page:/$admin/user/index/0', null, null, null, null);

	--select newid(), newid()

	exec a2ui.[Menu.Merge] @TenantId, @menu, @ModuleId;
end
go

------------------------------------------------
exec a2ui.[InvokeInitProcedures] @TenantId = 1;
go

