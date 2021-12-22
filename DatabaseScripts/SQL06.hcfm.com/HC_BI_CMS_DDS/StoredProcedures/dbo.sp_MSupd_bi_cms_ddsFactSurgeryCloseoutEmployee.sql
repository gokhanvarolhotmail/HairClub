/* CreateDate: 10/03/2019 23:03:42.597 , ModifyDate: 10/03/2019 23:03:42.597 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [sp_MSupd_bi_cms_ddsFactSurgeryCloseoutEmployee]
		@c1 int = NULL,
		@c2 int = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 uniqueidentifier = NULL,
		@c9 uniqueidentifier = NULL,
		@pkc1 int = NULL,
		@bitmap binary(2)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[FactSurgeryCloseoutEmployee] set
		[AppointmentKey] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AppointmentKey] end,
		[EmployeeKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [EmployeeKey] end,
		[CutCount] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CutCount] end,
		[PlaceCount] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [PlaceCount] end,
		[InsertAuditKey] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [UpdateAuditKey] end,
		[msrepl_tran_version] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [msrepl_tran_version] end,
		[SurgeryCloseOutEmployeeSSID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [SurgeryCloseOutEmployeeSSID] end
	where [SurgeryCloseOutEmployeeKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[SurgeryCloseOutEmployeeKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[FactSurgeryCloseoutEmployee]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
