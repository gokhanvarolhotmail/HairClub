/* CreateDate: 10/03/2019 23:03:40.090 , ModifyDate: 10/03/2019 23:03:40.090 */
GO
create procedure [dbo].[sp_MSupd_bi_cms_ddsDimAppointment]
		@c1 int = NULL,
		@c2 uniqueidentifier = NULL,
		@c3 int = NULL,
		@c4 int = NULL,
		@c5 int = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 uniqueidentifier = NULL,
		@c9 int = NULL,
		@c10 uniqueidentifier = NULL,
		@c11 datetime = NULL,
		@c12 int = NULL,
		@c13 nvarchar(50) = NULL,
		@c14 int = NULL,
		@c15 nvarchar(50) = NULL,
		@c16 int = NULL,
		@c17 nvarchar(50) = NULL,
		@c18 time = NULL,
		@c19 time = NULL,
		@c20 time = NULL,
		@c21 time = NULL,
		@c22 varchar(500) = NULL,
		@c23 varchar(50) = NULL,
		@c24 varchar(100) = NULL,
		@c25 varchar(50) = NULL,
		@c26 varchar(50) = NULL,
		@c27 tinyint = NULL,
		@c28 tinyint = NULL,
		@c29 tinyint = NULL,
		@c30 tinyint = NULL,
		@c31 datetime = NULL,
		@c32 datetime = NULL,
		@c33 varchar(200) = NULL,
		@c34 tinyint = NULL,
		@c35 int = NULL,
		@c36 int = NULL,
		@c37 binary(8) = NULL,
		@c38 uniqueidentifier = NULL,
		@c39 nvarchar(18) = NULL,
		@c40 nvarchar(18) = NULL,
		@pkc1 int = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
update [bi_cms_dds].[DimAppointment] set
		[AppointmentSSID] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AppointmentSSID] end,
		[CenterKey] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [CenterKey] end,
		[CenterSSID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [CenterSSID] end,
		[ClientHomeCenterKey] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ClientHomeCenterKey] end,
		[ClientHomeCenterSSID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [ClientHomeCenterSSID] end,
		[ClientKey] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ClientKey] end,
		[ClientSSID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ClientSSID] end,
		[ClientMembershipKey] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ClientMembershipKey] end,
		[ClientMembershipSSID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [ClientMembershipSSID] end,
		[AppointmentDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AppointmentDate] end,
		[ResourceSSID] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [ResourceSSID] end,
		[ResourceDescription] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [ResourceDescription] end,
		[ConfirmationTypeSSID] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [ConfirmationTypeSSID] end,
		[ConfirmationTypeDescription] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [ConfirmationTypeDescription] end,
		[AppointmentTypeSSID] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [AppointmentTypeSSID] end,
		[AppointmentTypeDescription] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [AppointmentTypeDescription] end,
		[AppointmentStartTime] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [AppointmentStartTime] end,
		[AppointmentEndTime] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [AppointmentEndTime] end,
		[CheckInTime] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CheckInTime] end,
		[CheckOutTime] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [CheckOutTime] end,
		[AppointmentSubject] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [AppointmentSubject] end,
		[AppointmentStatusSSID] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [AppointmentStatusSSID] end,
		[AppointmentStatusDescription] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [AppointmentStatusDescription] end,
		[OnContactActivitySSID] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [OnContactActivitySSID] end,
		[OnContactContactSSID] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [OnContactContactSSID] end,
		[CanPrinTCommentFlag] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [CanPrinTCommentFlag] end,
		[IsNonAppointmentFlag] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [IsNonAppointmentFlag] end,
		[IsDeletedFlag] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [IsDeletedFlag] end,
		[RowIsCurrent] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [RowIsCurrent] end,
		[RowStartDate] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [RowStartDate] end,
		[RowEndDate] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [RowEndDate] end,
		[RowChangeReason] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [RowChangeReason] end,
		[RowIsInferred] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [RowIsInferred] end,
		[InsertAuditKey] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [InsertAuditKey] end,
		[UpdateAuditKey] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [UpdateAuditKey] end,
		[RowTimeStamp] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [RowTimeStamp] end,
		[msrepl_tran_version] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [msrepl_tran_version] end,
		[SFDC_TaskID] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [SFDC_TaskID] end,
		[SFDC_LeadID] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [SFDC_LeadID] end
	where [AppointmentKey] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AppointmentKey] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[bi_cms_dds].[DimAppointment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
GO
