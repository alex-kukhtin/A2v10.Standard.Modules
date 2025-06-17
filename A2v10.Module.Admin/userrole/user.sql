-- USER
------------------------------------------------
create or alter procedure adm.[UserRole.Index]
@UserId bigint
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @cat table (Id bigint, [Name] nvarchar(255), [Url] nvarchar(255));
	insert into @cat (Id, [Name], [Url]) values
		(10, N'@[Users]',    N'/$admin/userrole/user/index/0');

	select [Items!TItem!Array] = null, [Id!!Id] = Id, [Name], [Url]
	from @cat
	order by Id;
end
go

------------------------------------------------
create or alter procedure adm.[User.Index]
@UserId bigint,
@Offset int = 0,
@PageSize int = 20,
@Order nvarchar(255) = N'username',
@Dir nvarchar(20) = N'asc',
@Fragment nvarchar(255) = null,
@Activity nchar(1) = N'A'
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	set @Order = lower(@Order);
	set @Dir = lower(@Dir);

	declare @fr nvarchar(255);
	declare @id bigint;
	set @fr = N'%' + @Fragment + N'%';
	set @id = try_cast(@Fragment as bigint);

	select [Users!TUser!Array] = null, [Id!!Id] = u.Id, [UserName] = u.UserName, u.PersonName, u.PhoneNumber, 
		u.Memo, u.Email, u.EmailConfirmed, u.PhoneNumberConfirmed, [DateCreated!!Utc]  = u.UtcDateCreated,
		[LastLoginDate!!Utc]  = u.LastLoginDate, u.IsExternalLogin, IsBlocked = isnull(u.IsBlocked, 0),
		[!!RowCount] = count(*) over()
	from a2security.Users u 
		where Void = 0 and Id <> 0 and IsApiUser = 0
		and (@Activity = N'L' or @Activity = N'A' and u.IsBlocked = 0 or @Activity = N'B' and u.IsBlocked = 1)
		and (@fr is null or u.UserName like @fr or u.PersonName like @fr or u.Memo like @fr or u.Id = @id)
	order by 
		case when @Dir = N'asc' then
			case @Order 
				when N'id' then u.[Id]
			end
		end asc,
		case when @Dir = N'asc' then
			case @Order 
				when N'datecreated' then u.[UtcDateCreated]
				when N'lastlogindate' then u.[LastLoginDate]
			end
		end asc,
		case when @Dir = N'asc' then
			case @Order 
				when N'username' then u.[UserName]
				when N'personname' then u.PersonName
				when N'memo' then u.[Memo]
			end
		end asc,
		case when @Dir = N'desc' then
			case @Order 
				when N'id' then u.[Id]
			end
		end desc,
		case when @Dir = N'desc' then
			case @Order
				when N'datecreated' then u.[UtcDateCreated]
				when N'lastlogindate' then u.[LastLoginDate]
			end
		end desc,
		case when @Dir = N'desc' then
			case @Order
				when N'username' then u.[UserName]
				when N'personname' then u.PersonName
				when N'memo' then u.[Memo]
			end
		end desc
	offset @Offset rows fetch next @PageSize rows only
	option (recompile);

	select [!$System!] = null, [!Users!Offset] = @Offset, [!Users!PageSize] = @PageSize, 
		[!Users!SortOrder] = @Order, [!Users!SortDir] = @Dir,
		[!Users.Fragment!Filter] = @Fragment, [!Users.Activity!Filter] = @Activity;
end
go

------------------------------------------------
create or alter procedure adm.[User.Load]
@UserId bigint,
@Id bigint = null
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	select [User!TUser!Object] = null, [Id!!Id] = u.Id, u.UserName, u.PersonName, u.PhoneNumber, 
		u.Email,  u.Memo, u.EmailConfirmed, IsBlocked, [Password] = cast(null as nvarchar(255)),
		[Roles!TRole!Array] = null
	from a2security.Users u where u.Id = @Id and IsApiUser = 0;

	/*
	select [!TRole!Array] = null, [Id!!Id] = ur.Id, [Role] = ur.[Role], [Name] = r.[Name],
		[!TUser.Roles!ParentId] = ur.[User]
	from appsec.UserRoles ur
	inner join appsec.Roles r on ur.[Role] = r.Id
	where ur.[User] = @Id;
	*/
end
go

------------------------------------------------
drop procedure if exists adm.[User.Metadata];
drop procedure if exists adm.[User.Update];
drop type if exists adm.[User.TableType];
go
------------------------------------------------
create type adm.[User.TableType] as table (
	Id bigint,
	UserName nvarchar(255),
	PhoneNumber nvarchar(255),
	PersonName nvarchar(255),
	Memo nvarchar(255)
)
go
------------------------------------------------
create or alter procedure adm.[User.Metadata]
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @User adm.[User.TableType];
	select [User!User!Metadata] = null, * from @User;
end
go
------------------------------------------------
create or alter procedure adm.[User.Update]
@UserId bigint = null,
@User adm.[User.TableType] readonly
as
begin
	set nocount on;
	set transaction isolation level read uncommitted;

	declare @rtable table(id bigint);
	declare @id bigint;

	merge a2security.Users as t
	using @User as s
	on t.Id = s.Id
	when matched then update set
		t.PersonName = s.PersonName,
		t.PhoneNumber = s.PhoneNumber,
		t.Memo = s.Memo
	when not matched then insert
		([UserName], SetPassword, SecurityStamp, PersonName, PhoneNumber, Memo) values
		(s.UserName, 1, N'', s.PersonName, s.PhoneNumber, s.Memo)
	output inserted.Id into @rtable(id);
	
	select top(1) @id = id from @rtable;

	exec adm.[User.Load] @UserId = @UserId, @Id = @id;
end
go
------------------------------------------------
create or alter procedure adm.[User.Delete]
@UserId bigint,
@Id bigint
as
begin
	set nocount on;
	set transaction isolation level read committed;

	update a2security.Users set Void = 1, UserName = UserName + N'_' +  cast(newid() as nvarchar(50)) 
		where Id = @Id;
end
go


