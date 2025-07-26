-- INBOX
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'a2wf' and TABLE_NAME=N'Inbox')
create table a2wf.[Inbox]
(
	Id uniqueidentifier not null,
	InstanceId uniqueidentifier not null
		constraint FK_Inbox_InstanceId_Instances foreign key references a2wf.Instances(Id),
	Bookmark nvarchar(255) not null,
	Activity nvarchar(255),
	DateCreated datetime not null
		constraint DF_Inbox_DateCreated default(getutcdate()),
	DateRemoved datetime null,
	Void bit not null
		constraint DF_Inbox_Void default(0),
	[User] bigint,
	[Role] bigint,
	[Url] nvarchar(255),
	[Text] nvarchar(255),
	-- other fields
	constraint PK_Inbox primary key clustered(Id, InstanceId)
);
go

------------------------------------------------
create or alter procedure a2wf.[Inbox.CancelChildren]
@InstanceId uniqueidentifier
as
begin
	set nocount on;
	set transaction isolation level read committed;

	update a2wf.Inbox set Void = 1, DateRemoved = getutcdate()
	from a2wf.Inbox b inner join a2wf.Instances i on b.InstanceId = i.Id
	where i.Parent = @InstanceId;
end
go

------------------------------------------------
if not exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_SCHEMA=N'a2wf' and ROUTINE_NAME=N'Instance.Inbox.Create')
	exec sp_executesql N'
	create procedure a2wf.[Instance.Inbox.Create]
	@UserId bigint = null,
	@Id uniqueidentifier,
	@InstanceId uniqueidentifier,
	@Bookmark nvarchar(255),
	@Activity nvarchar(255),
	@User bigint,
	@Role bigint,
	@Text nvarchar(255),
	@Url nvarchar(255)
	as
	begin
		set nocount on;
		set transaction isolation level read committed;
		set xact_abort on;

		insert into a2wf.[Inbox] (Id, InstanceId, Bookmark, Activity, [User], [Role], [Text], [Url]) -- other fields
		values (@Id, @InstanceId, @Bookmark, @Activity, @User, @Role, @Text, @Url); -- other parameters
	end
	';
go
------------------------------------------------
if not exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_SCHEMA=N'a2wf' and ROUTINE_NAME=N'Instance.Inbox.Remove')
	exec sp_executesql N'
	create procedure a2wf.[Instance.Inbox.Remove]
	@UserId bigint = null,
	@Id uniqueidentifier,
	@InstanceId uniqueidentifier
	as
	begin
		set nocount on;
		set transaction isolation level read committed;
		set xact_abort on;

		update a2wf.Inbox set Void = 1, DateRemoved = getutcdate() where Id=@Id and InstanceId=@InstanceId;
	end
	';
go


/*
drop table a2wf.Inbox;
drop procedure a2wf.[Instance.Inbox.Remove];
drop procedure a2wf.[Instance.Inbox.Create];
*/
