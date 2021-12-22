/* CreateDate: 10/03/2019 23:03:40.393 , ModifyDate: 10/03/2019 23:03:40.393 */
GO
create procedure [sp_MSupd_bi_cms_ddsDimEmployeePosition]
		@c1 int = NULL,
		@c2 nvarchar(50) = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(10) = NULL,
		@c5 int = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 bit = NULL,
		@c8 bit = NULL,
		@c9 bit = NULL,
		@c10 bit = NULL,
		@c11 bit = NULL,
		@c12 bit = NULL,
		@c13 int = NULL,
		@c14 bit = NULL,
		@c15 bit = NULL,
		@c16 bit = NULL,
		@c17 nchar(1) = NULL,
		@c18 tinyint = NULL,
		@c19 datetime = NULL,
		@c20 datetime = NULL,
		@c21 varchar(200) = NULL,
		@c22 tinyint = NULL,
		@c23 int = NULL,
		@c24 int = NULL,
		@c25 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(4)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimEmployeePosition] set
		[EmployeePositionSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [EmployeePositionSSID] end,
		[EmployeePositionDescription] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeePositionDescription] end,
		[EmployeePositionDescriptionShort] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EmployeePositionDescriptionShort] end,
		[EmployeePositionSortOrder] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EmployeePositionSortOrder] end,
		[ActiveDirectoryGroup] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ActiveDirectoryGroup] end,
		[IsAdministratorFlag] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [IsAdministratorFlag] end,
		[IsEmployeeOneFlag] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [IsEmployeeOneFlag] end,
		[IsEmployeeTwoFlag] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [IsEmployeeTwoFlag] end,
		[IsEmployeeThreeFlag] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [IsEmployeeThreeFlag] end,
		[IsEmployeeFourFlag] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [IsEmployeeFourFlag] end,
		[CanScheduleFlag] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CanScheduleFlag] end,
		[ApplicationTimeoutMinutes] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ApplicationTimeoutMinutes] end,
		[UseDefaultCenterFlag] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [UseDefaultCenterFlag] end,
		[IsSurgeryCenterEmployeeFlag] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [IsSurgeryCenterEmployeeFlag] end,
		[IsNonSurgeryCenterEmployeeFlag] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [IsNonSurgeryCenterEmployeeFlag] end,
		[Active] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [Active] end,
		[RowIsCurrent] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [msrepl_tran_version] end
	where [EmployeePositionKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeePositionKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimEmployeePosition]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
