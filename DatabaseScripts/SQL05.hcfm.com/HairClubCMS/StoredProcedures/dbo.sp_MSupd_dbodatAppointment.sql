/* CreateDate: 05/05/2020 17:42:47.613 , ModifyDate: 05/05/2020 17:42:47.613 */
GO
create procedure [sp_MSupd_dbodatAppointment]
		@c1 uniqueidentifier = NULL,
		@c2 int = NULL,
		@c3 uniqueidentifier = NULL,
		@c4 uniqueidentifier = NULL,
		@c5 uniqueidentifier = NULL,
		@c6 int = NULL,
		@c7 int = NULL,
		@c8 int = NULL,
		@c9 int = NULL,
		@c10 int = NULL,
		@c11 date = NULL,
		@c12 time(0) = NULL,
		@c13 time(0) = NULL,
		@c14 datetime = NULL,
		@c15 datetime = NULL,
		@c16 nvarchar(500) = NULL,
		@c17 bit = NULL,
		@c18 bit = NULL,
		@c19 varchar(1024) = NULL,
		@c20 datetime = NULL,
		@c21 nvarchar(25) = NULL,
		@c22 datetime = NULL,
		@c23 nvarchar(25) = NULL,
		@c24 int = NULL,
		@c25 bit = NULL,
		@c26 nchar(10) = NULL,
		@c27 nchar(10) = NULL,
		@c28 bit = NULL,
		@c29 nvarchar(25) = NULL,
		@c30 datetime = NULL,
		@c31 int = NULL,
		@c32 int = NULL,
		@c33 int = NULL,
		@c34 bit = NULL,
		@c35 nvarchar(18) = NULL,
		@c36 nvarchar(18) = NULL,
		@c37 int = NULL,
		@c38 datetime = NULL,
		@c39 datetime = NULL,
		@c40 bit = NULL,
		@pkc1 uniqueidentifier = NULL,
		@bitmap binary(5)
as
begin
	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 1 = 1)
begin
update [dbo].[datAppointment] set
		[AppointmentGUID] = case substring(@bitmap,1,1) & 1 when 1 then @c1 else [AppointmentGUID] end,
		[AppointmentID_Temp] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AppointmentID_Temp] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientMembershipGUID] end,
		[ParentAppointmentGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ParentAppointmentGUID] end,
		[CenterID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CenterID] end,
		[ClientHomeCenterID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ClientHomeCenterID] end,
		[ResourceID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ResourceID] end,
		[ConfirmationTypeID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ConfirmationTypeID] end,
		[AppointmentTypeID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [AppointmentTypeID] end,
		[AppointmentDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AppointmentDate] end,
		[StartTime] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [StartTime] end,
		[EndTime] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [EndTime] end,
		[CheckinTime] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CheckinTime] end,
		[CheckoutTime] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CheckoutTime] end,
		[AppointmentSubject] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [AppointmentSubject] end,
		[CanPrintCommentFlag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CanPrintCommentFlag] end,
		[IsNonAppointmentFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsNonAppointmentFlag] end,
		[RecurrenceRule] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RecurrenceRule] end,
		[CreateDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [LastUpdateUser] end,
		[AppointmentStatusID] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [AppointmentStatusID] end,
		[IsDeletedFlag] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [IsDeletedFlag] end,
		[OnContactActivityID] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [OnContactActivityID] end,
		[OnContactContactID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [OnContactContactID] end,
		[IsAuthorizedFlag] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [IsAuthorizedFlag] end,
		[LastChangeUser] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [LastChangeUser] end,
		[LastChangeDate] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [LastChangeDate] end,
		[ScalpHealthID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [ScalpHealthID] end,
		[AppointmentPriorityColorID] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [AppointmentPriorityColorID] end,
		[CompletedVisitTypeID] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [CompletedVisitTypeID] end,
		[IsFullTrichoView] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [IsFullTrichoView] end,
		[SalesforceContactID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [SalesforceContactID] end,
		[SalesforceTaskID] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [SalesforceTaskID] end,
		[KorvueID] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [KorvueID] end,
		[ServiceStartTime] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [ServiceStartTime] end,
		[ServiceEndTime] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [ServiceEndTime] end,
		[IsClientContactInformationConfirmed] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [IsClientContactInformationConfirmed] end
	where [AppointmentGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AppointmentGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAppointment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
else
begin
update [dbo].[datAppointment] set
		[AppointmentID_Temp] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [AppointmentID_Temp] end,
		[ClientGUID] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [ClientGUID] end,
		[ClientMembershipGUID] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [ClientMembershipGUID] end,
		[ParentAppointmentGUID] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [ParentAppointmentGUID] end,
		[CenterID] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [CenterID] end,
		[ClientHomeCenterID] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [ClientHomeCenterID] end,
		[ResourceID] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [ResourceID] end,
		[ConfirmationTypeID] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [ConfirmationTypeID] end,
		[AppointmentTypeID] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [AppointmentTypeID] end,
		[AppointmentDate] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [AppointmentDate] end,
		[StartTime] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [StartTime] end,
		[EndTime] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [EndTime] end,
		[CheckinTime] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [CheckinTime] end,
		[CheckoutTime] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [CheckoutTime] end,
		[AppointmentSubject] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [AppointmentSubject] end,
		[CanPrintCommentFlag] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [CanPrintCommentFlag] end,
		[IsNonAppointmentFlag] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [IsNonAppointmentFlag] end,
		[RecurrenceRule] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [RecurrenceRule] end,
		[CreateDate] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [CreateDate] end,
		[CreateUser] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [CreateUser] end,
		[LastUpdate] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [LastUpdate] end,
		[LastUpdateUser] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [LastUpdateUser] end,
		[AppointmentStatusID] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [AppointmentStatusID] end,
		[IsDeletedFlag] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [IsDeletedFlag] end,
		[OnContactActivityID] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [OnContactActivityID] end,
		[OnContactContactID] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [OnContactContactID] end,
		[IsAuthorizedFlag] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [IsAuthorizedFlag] end,
		[LastChangeUser] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [LastChangeUser] end,
		[LastChangeDate] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [LastChangeDate] end,
		[ScalpHealthID] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [ScalpHealthID] end,
		[AppointmentPriorityColorID] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [AppointmentPriorityColorID] end,
		[CompletedVisitTypeID] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [CompletedVisitTypeID] end,
		[IsFullTrichoView] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [IsFullTrichoView] end,
		[SalesforceContactID] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [SalesforceContactID] end,
		[SalesforceTaskID] = case substring(@bitmap,5,1) & 8 when 8 then @c36 else [SalesforceTaskID] end,
		[KorvueID] = case substring(@bitmap,5,1) & 16 when 16 then @c37 else [KorvueID] end,
		[ServiceStartTime] = case substring(@bitmap,5,1) & 32 when 32 then @c38 else [ServiceStartTime] end,
		[ServiceEndTime] = case substring(@bitmap,5,1) & 64 when 64 then @c39 else [ServiceEndTime] end,
		[IsClientContactInformationConfirmed] = case substring(@bitmap,5,1) & 128 when 128 then @c40 else [IsClientContactInformationConfirmed] end
	where [AppointmentGUID] = @pkc1
if @@rowcount = 0
    if @@microsoftversion>0x07320000
		Begin
			if exists (Select * from sys.all_parameters where object_id = OBJECT_ID('sp_MSreplraiserror') and [name] = '@param3')
			Begin

				set @primarykey_text = @primarykey_text + '[AppointmentGUID] = ' + convert(nvarchar(100),@pkc1,1)
				exec sp_MSreplraiserror @errorid=20598, @param1=N'[dbo].[datAppointment]', @param2=@primarykey_text, @param3=13233
			End
			Else
				exec sp_MSreplraiserror @errorid=20598
		End
end
end
GO
