/* CreateDate: 05/05/2020 17:42:55.437 , ModifyDate: 05/05/2020 17:42:55.437 */
GO
create procedure [sp_MSupd_dbomtnActiveDirectoryImport]
		@c1 int = NULL,
		@c2 varbinary(100) = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 nvarchar(50) = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 nvarchar(5) = NULL,
		@c10 datetime = NULL,
		@c11 nvarchar(20) = NULL,
		@c12 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [dbo].[mtnActiveDirectoryImport] set
		[ADSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [ADSID] end,
		[ADUserLogin] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ADUserLogin] end,
		[ADCenter] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ADCenter] end,
		[ADFirstName] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ADFirstName] end,
		[ADLastName] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ADLastName] end,
		[CenterID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [CenterID] end,
		[EmployeePositionID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EmployeePositionID] end,
		[EmployeeInitials] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [EmployeeInitials] end,
		[CreateDate] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [CreateDate] end,
		[EmployeePayrollID] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [EmployeePayrollID] end,
		[EmployeeTitleID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [EmployeeTitleID] end
	where [ActiveDirectoryID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[ActiveDirectoryID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[mtnActiveDirectoryImport]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
