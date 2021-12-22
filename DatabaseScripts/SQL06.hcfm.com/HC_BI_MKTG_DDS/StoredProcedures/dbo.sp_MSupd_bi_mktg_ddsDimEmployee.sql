/* CreateDate: 09/03/2021 09:37:06.000 , ModifyDate: 09/03/2021 09:37:06.000 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_mktg_ddsDimEmployee]
		@c1 int = NULL,
		@c2 nvarchar(20) = NULL,
		@c3 nvarchar(50) = NULL,
		@c4 nvarchar(80) = NULL,
		@c5 nvarchar(50) = NULL,
		@c6 nvarchar(50) = NULL,
		@c7 nvarchar(50) = NULL,
		@c8 nvarchar(10) = NULL,
		@c9 nvarchar(50) = NULL,
		@c10 nvarchar(10) = NULL,
		@c11 nvarchar(50) = NULL,
		@c12 tinyint = NULL,
		@c13 datetime = NULL,
		@c14 datetime = NULL,
		@c15 varchar(200) = NULL,
		@c16 tinyint = NULL,
		@c17 int = NULL,
		@c18 int = NULL,
		@pkc1 int = NULL,
		@bitmap binary(3)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_mktg_dds].[DimEmployee] set
		[EmployeeSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [EmployeeSSID] end,
		[EmployeeFirstName] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeeFirstName] end,
		[EmployeeLastName] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [EmployeeLastName] end,
		[EmployeeDescription] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [EmployeeDescription] end,
		[EmployeeTitle] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [EmployeeTitle] end,
		[ActionSetCode] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ActionSetCode] end,
		[EmployeeDepartmentSSID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [EmployeeDepartmentSSID] end,
		[EmployeeDepartmentDescription] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [EmployeeDepartmentDescription] end,
		[EmployeeJobFunctionSSID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [EmployeeJobFunctionSSID] end,
		[EmployeeJobFunctionDescription] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [EmployeeJobFunctionDescription] end,
		[RowIsCurrent] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [UpdateAuditKey] end
	where [EmployeeKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[EmployeeKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_mktg_dds].[DimEmployee]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
