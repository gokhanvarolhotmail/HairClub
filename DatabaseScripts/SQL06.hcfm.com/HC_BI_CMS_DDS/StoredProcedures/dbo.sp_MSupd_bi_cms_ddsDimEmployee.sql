/* CreateDate: 03/17/2022 11:57:04.783 , ModifyDate: 03/17/2022 11:57:04.783 */
GO
create procedure [sp_MSupd_bi_cms_ddsDimEmployee]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(50) = NULL,
		@c5 nvarchar(5) = NULL,
		@c6 int = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 nvarchar(10) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(50) = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 nvarchar(50) = NULL,
		@c13 nvarchar(10) = NULL,
		@c14 nvarchar(50) = NULL,
		@c15 nvarchar(10) = NULL,
		@c16 nvarchar(50) = NULL,
		@c17 nvarchar(15) = NULL,
		@c18 nvarchar(50) = NULL,
		@c19 nvarchar(25) = NULL,
		@c20 nvarchar(25) = NULL,
		@c21 nvarchar(100) = NULL,
		@c22 nvarchar(20) = NULL,
		@c23 nvarchar(20) = NULL,
		@c24 tinyint = NULL,
		@c25 datetime = NULL,
		@c26 datetime = NULL,
		@c27 varchar(200) = NULL,
		@c28 tinyint = NULL,
		@c29 int = NULL,
		@c30 int = NULL,
		@c31 uniqueidentifier = NULL,
		@c32 int = NULL,
		@c33 nvarchar(20) = NULL,
		@c34 bit = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimEmployee] set
		[EmployeeSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [EmployeeSSID] end,
		[EmployeeFirstName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeeFirstName] end,
		[EmployeeLastName] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EmployeeLastName] end,
		[EmployeeInitials] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EmployeeInitials] end,
		[SalutationSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [SalutationSSID] end,
		[EmployeeSalutationDescription] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [EmployeeSalutationDescription] end,
		[EmployeeSalutationDescriptionShort] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EmployeeSalutationDescriptionShort] end,
		[EmployeeAddress1] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [EmployeeAddress1] end,
		[EmployeeAddress2] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [EmployeeAddress2] end,
		[EmployeeAddress3] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [EmployeeAddress3] end,
		[CountryRegionDescription] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [CountryRegionDescription] end,
		[CountryRegionDescriptionShort] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [CountryRegionDescriptionShort] end,
		[StateProvinceDescription] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [StateProvinceDescription] end,
		[StateProvinceDescriptionShort] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [StateProvinceDescriptionShort] end,
		[City] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [City] end,
		[PostalCode] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [PostalCode] end,
		[UserLogin] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [UserLogin] end,
		[EmployeePhoneMain] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [EmployeePhoneMain] end,
		[EmployeePhoneAlternate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [EmployeePhoneAlternate] end,
		[EmployeeEmergencyContact] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [EmployeeEmergencyContact] end,
		[EmployeePayrollNumber] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [EmployeePayrollNumber] end,
		[EmployeeTimeClockNumber] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [EmployeeTimeClockNumber] end,
		[RowIsCurrent] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [msrepl_tran_version] end,
		[CenterSSID] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [CenterSSID] end,
		[EmployeePayrollID] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [EmployeePayrollID] end,
		[IsActiveFlag] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [IsActiveFlag] end
	where [EmployeeKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeeKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimEmployee]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
