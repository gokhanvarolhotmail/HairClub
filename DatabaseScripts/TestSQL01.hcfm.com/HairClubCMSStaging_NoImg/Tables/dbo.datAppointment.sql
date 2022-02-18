/* CreateDate: 01/29/2009 15:36:51.077 , ModifyDate: 01/31/2022 08:32:31.880 */
GO
CREATE TABLE [dbo].[datAppointment](
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[AppointmentID_Temp] [int] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[ParentAppointmentGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[ClientHomeCenterID] [int] NULL,
	[ResourceID] [int] NULL,
	[ConfirmationTypeID] [int] NULL,
	[AppointmentTypeID] [int] NULL,
	[AppointmentDate] [date] NULL,
	[StartTime] [time](0) NULL,
	[EndTime] [time](0) NULL,
	[CheckinTime] [datetime] NULL,
	[CheckoutTime] [datetime] NULL,
	[AppointmentSubject] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CanPrintCommentFlag] [bit] NULL,
	[IsNonAppointmentFlag] [bit] NULL,
	[RecurrenceRule] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDateTimeCalc]  AS (CONVERT([datetime],[AppointmentDate],(0))+CONVERT([datetime],[StartTime],(0))),
	[EndDateTimeCalc]  AS (CONVERT([datetime],[AppointmentDate],(0))+CONVERT([datetime],[EndTime],(0))),
	[AppointmentDurationCalc]  AS (isnull(datediff(minute,[starttime],[endtime]),(0))),
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[AppointmentStatusID] [int] NULL,
	[IsDeletedFlag] [bit] NULL,
	[OnContactActivityID] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnContactContactID] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CheckedInFlag]  AS (case when [checkintime] IS NULL then (0) else (1) end),
	[IsAuthorizedFlag] [bit] NOT NULL,
	[LastChangeUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastChangeDate] [datetime] NOT NULL,
	[ScalpHealthID] [int] NULL,
	[AppointmentPriorityColorID] [int] NULL,
	[CompletedVisitTypeID] [int] NULL,
	[IsFullTrichoView] [bit] NOT NULL,
	[SalesforceContactID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesforceTaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[KorvueID] [int] NULL,
	[ServiceStartTime] [datetime] NULL,
	[ServiceEndTime] [datetime] NULL,
	[IsClientContactInformationConfirmed] [bit] NULL,
 CONSTRAINT [PK_datAppointment] PRIMARY KEY CLUSTERED
(
	[AppointmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_AppointmentDate] ON [dbo].[datAppointment]
(
	[AppointmentDate] ASC
)
INCLUDE([AppointmentID_Temp],[ClientGUID],[ClientMembershipGUID],[ParentAppointmentGUID],[CenterID],[ClientHomeCenterID],[ResourceID],[ConfirmationTypeID],[AppointmentTypeID],[StartTime],[EndTime],[CheckinTime],[CheckoutTime],[AppointmentSubject],[CanPrintCommentFlag],[IsNonAppointmentFlag],[RecurrenceRule],[StartDateTimeCalc],[EndDateTimeCalc],[AppointmentDurationCalc],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[AppointmentStatusID],[IsDeletedFlag],[OnContactActivityID],[OnContactContactID],[CheckedInFlag],[IsAuthorizedFlag],[LastChangeUser],[LastChangeDate],[ScalpHealthID],[AppointmentPriorityColorID],[CompletedVisitTypeID],[IsFullTrichoView],[SalesforceContactID],[SalesforceTaskID],[KorvueID],[ServiceStartTime],[ServiceEndTime],[IsClientContactInformationConfirmed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_AppointmentDate_CenterID_IsDeletedFlag_AppointmentTypeID_OnContactContactID] ON [dbo].[datAppointment]
(
	[AppointmentDate] DESC,
	[CenterID] ASC,
	[IsDeletedFlag] ASC,
	[AppointmentTypeID] ASC,
	[OnContactContactID] ASC
)
INCLUDE([ClientGUID],[ClientMembershipGUID],[ConfirmationTypeID],[StartTime],[EndTime],[CheckinTime],[CheckoutTime],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[AppointmentStatusID],[OnContactActivityID],[IsAuthorizedFlag],[LastChangeUser],[LastChangeDate],[SalesforceTaskID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_AppointmentDate_ClientGUID_IsDeleted_CheckedInFlag] ON [dbo].[datAppointment]
(
	[AppointmentDate] DESC,
	[ClientGUID] ASC,
	[IsDeletedFlag] ASC,
	[CheckedInFlag] ASC
)
INCLUDE([AppointmentGUID],[CenterID],[StartTime],[EndTime],[ClientMembershipGUID],[ConfirmationTypeID],[AppointmentTypeID],[CheckinTime],[CheckoutTime],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[AppointmentStatusID],[OnContactActivityID],[IsAuthorizedFlag],[LastChangeUser],[LastChangeDate],[SalesforceTaskID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_AppointmentDate_SalesforceContactID] ON [dbo].[datAppointment]
(
	[AppointmentDate] ASC,
	[SalesforceContactID] ASC
)
INCLUDE([AppointmentID_Temp],[ClientGUID],[ClientMembershipGUID],[ParentAppointmentGUID],[CenterID],[ClientHomeCenterID],[ResourceID],[ConfirmationTypeID],[AppointmentTypeID],[StartTime],[EndTime],[CheckinTime],[CheckoutTime],[AppointmentSubject],[CanPrintCommentFlag],[IsNonAppointmentFlag],[RecurrenceRule],[StartDateTimeCalc],[EndDateTimeCalc],[AppointmentDurationCalc],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[AppointmentStatusID],[IsDeletedFlag],[OnContactActivityID],[OnContactContactID],[CheckedInFlag],[IsAuthorizedFlag],[LastChangeUser],[LastChangeDate],[ScalpHealthID],[AppointmentPriorityColorID],[CompletedVisitTypeID],[IsFullTrichoView],[SalesforceTaskID],[KorvueID],[ServiceStartTime],[ServiceEndTime],[IsClientContactInformationConfirmed]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_ClientGUID_IsDeletedFlag] ON [dbo].[datAppointment]
(
	[ClientGUID] ASC,
	[IsDeletedFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_ClientGUID_IsDeletedFlag_AppointmentDate] ON [dbo].[datAppointment]
(
	[ClientGUID] ASC,
	[IsDeletedFlag] ASC,
	[AppointmentDate] ASC
)
INCLUDE([AppointmentGUID],[StartTime],[CheckinTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_ClientMembershipGUID_IsDeletedFlag_CheckedInFlag_AppointmentDate] ON [dbo].[datAppointment]
(
	[ClientMembershipGUID] ASC,
	[IsDeletedFlag] ASC,
	[CheckedInFlag] ASC,
	[AppointmentDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_IsDeletedFlag_AppointmentDate] ON [dbo].[datAppointment]
(
	[IsDeletedFlag] ASC,
	[AppointmentDate] ASC
)
INCLUDE([AppointmentGUID],[ClientGUID],[StartTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_datAppointment_OnContactActivityID_CheckoutTime_AppointmentGUID] ON [dbo].[datAppointment]
(
	[OnContactActivityID] ASC,
	[CheckoutTime] DESC,
	[AppointmentGUID] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_SalesforceContactID_Inc_LastUpdate_UpdateStamp] ON [dbo].[datAppointment]
(
	[SalesforceContactID] ASC
)
INCLUDE([LastUpdate],[UpdateStamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datAppointment_CenterID_AppointmentTypeID_INCLAASEI] ON [dbo].[datAppointment]
(
	[CenterID] ASC,
	[AppointmentTypeID] ASC
)
INCLUDE([AppointmentGUID],[AppointmentDate],[StartTime],[EndTime],[IsDeletedFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [RP_datAppointment_CheckinTime] ON [dbo].[datAppointment]
(
	[CheckinTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAppointment] ADD  CONSTRAINT [DF_datAppointment_CanPrintCommentFlag]  DEFAULT ((0)) FOR [CanPrintCommentFlag]
GO
ALTER TABLE [dbo].[datAppointment] ADD  CONSTRAINT [DF_datAppointment_IsNonAppointmentFlag]  DEFAULT ((0)) FOR [IsNonAppointmentFlag]
GO
ALTER TABLE [dbo].[datAppointment] ADD  CONSTRAINT [DF_datAppointment_IsDeletedFlag]  DEFAULT ((0)) FOR [IsDeletedFlag]
GO
ALTER TABLE [dbo].[datAppointment] ADD  DEFAULT ((0)) FOR [IsAuthorizedFlag]
GO
ALTER TABLE [dbo].[datAppointment] ADD  CONSTRAINT [DF_datAppointment_IsFullTrichoView]  DEFAULT ((0)) FOR [IsFullTrichoView]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_cfgCenter]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_cfgCenter1] FOREIGN KEY([ClientHomeCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_cfgCenter1]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_cfgResource] FOREIGN KEY([ResourceID])
REFERENCES [dbo].[cfgResource] ([ResourceID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_cfgResource]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_datAppointment] FOREIGN KEY([ParentAppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_datAppointment]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_datClient]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_datClientMembership]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_lkpAppointmentPriorityColor] FOREIGN KEY([AppointmentPriorityColorID])
REFERENCES [dbo].[lkpAppointmentPriorityColor] ([AppointmentPriorityColorID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_lkpAppointmentPriorityColor]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_lkpAppointmentStatus] FOREIGN KEY([AppointmentStatusID])
REFERENCES [dbo].[lkpAppointmentStatus] ([AppointmentStatusID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_lkpAppointmentStatus]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_lkpAppointmentType] FOREIGN KEY([AppointmentTypeID])
REFERENCES [dbo].[lkpAppointmentType] ([AppointmentTypeID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_lkpAppointmentType]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_lkpCompletedVisitType] FOREIGN KEY([CompletedVisitTypeID])
REFERENCES [dbo].[lkpCompletedVisitType] ([CompletedVisitTypeID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_lkpCompletedVisitType]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_lkpConfirmationType] FOREIGN KEY([ConfirmationTypeID])
REFERENCES [dbo].[lkpConfirmationType] ([ConfirmationTypeID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_lkpConfirmationType]
GO
ALTER TABLE [dbo].[datAppointment]  WITH CHECK ADD  CONSTRAINT [FK_datAppointment_lkpScalpHealth] FOREIGN KEY([ScalpHealthID])
REFERENCES [dbo].[lkpScalpHealth] ([ScalpHealthID])
GO
ALTER TABLE [dbo].[datAppointment] CHECK CONSTRAINT [FK_datAppointment_lkpScalpHealth]
GO
