-- TRACK
------------------------------------------------
if not exists(select * from INFORMATION_SCHEMA.TABLES where TABLE_SCHEMA=N'a2wf' and TABLE_NAME=N'UserTrack')
create table a2wf.[UserTrack]
(
	Id bigint not null identity(100, 1),
	InstanceId uniqueidentifier not null
		constraint FK_UserTrack_InstanceId_Instances foreign key references a2wf.Instances(Id),
	Activity nvarchar(255),
	DateCreated datetime not null
		constraint DF_UserTrack_DateCreated default(getutcdate()),
	[UserId] bigint,
	[RoleId] bigint,
	[Message] nvarchar(1023),
	-- other fields
	constraint PK_UserTrack primary key clustered(Id, InstanceId)
);
go
------------------------------------------------
if not exists (select * from INFORMATION_SCHEMA.ROUTINES where ROUTINE_SCHEMA=N'a2wf' and ROUTINE_NAME=N'Instance.UserTrack.Add')
	exec sp_executesql N'
	create procedure a2wf.[Instance.UserTrack.Add]
	@UserId bigint = null,
	@RoleId bigint = null,
	@InstanceId uniqueidentifier,
	@Activity nvarchar(255) = null,
	@Message nvarchar(255) = null
	-- other fields
	as
	begin
		set nocount on;
		set transaction isolation level read committed;
		set xact_abort on;

		insert into a2wf.[UserTrack] (InstanceId, Activity, [UserId], RoleId, [Message]
			-- other fields
		) 
		values (@InstanceId, @Activity, @UserId, @RoleId, @Message
			-- other parameters
		);
	end
	';
go
