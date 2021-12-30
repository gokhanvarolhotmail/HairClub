/* CreateDate: 05/05/2020 17:42:47.593 , ModifyDate: 05/05/2020 18:41:08.480 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointment_ClientGUID_IsDeletedFlag_AppointmentDate] ON [dbo].[datAppointment]
(
	[ClientGUID] ASC,
	[IsDeletedFlag] ASC,
	[AppointmentDate] ASC
)
INCLUDE([AppointmentGUID],[StartTime]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
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
CREATE NONCLUSTERED INDEX [IX_datAppointment_SalesforceTaskID_INCL] ON [dbo].[datAppointment]
(
	[SalesforceTaskID] ASC
)
INCLUDE([AppointmentDate],[StartTime],[CheckinTime],[CheckoutTime],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
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
