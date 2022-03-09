/* CreateDate: 12/06/2017 16:41:52.817 , ModifyDate: 03/08/2022 19:49:07.577 */
GO
CREATE TABLE [dbo].[datClientMessageLog](
	[ClientMessageLogID] [int] IDENTITY(1,1) NOT NULL,
	[TextMessageProcessID] [int] NOT NULL,
	[SessionGUID] [uniqueidentifier] NOT NULL,
	[BatchID] [int] NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[EmailAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientPhoneNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LanguageID] [int] NULL,
	[LanguageCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[AppointmentDate] [date] NOT NULL,
	[AppointmentTime] [time](7) NOT NULL,
	[CenterID] [int] NOT NULL,
	[CenterName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterAddressLine1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddressLine2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterCity] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterStateCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterCountryCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterTimeZone] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterPhoneNumber] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Employee1First_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee1Last_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee1Position] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee2First_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee2Last_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Employee2Position] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Stylist_First_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Stylist_Last_Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TextMessage] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TextMessageStatusID] [int] NOT NULL,
	[ErrorCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorVerbiage] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsReprocessFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datClientMessageLog] PRIMARY KEY CLUSTERED
(
	[ClientMessageLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMessageLog_AppointmentGUID] ON [dbo].[datClientMessageLog]
(
	[AppointmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMessageLog_BatchID] ON [dbo].[datClientMessageLog]
(
	[BatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMessageLog_ClientIdentifier] ON [dbo].[datClientMessageLog]
(
	[ClientIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMessageLog_IsReprocessFlag] ON [dbo].[datClientMessageLog]
(
	[IsReprocessFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMessageLog_SessionGUID] ON [dbo].[datClientMessageLog]
(
	[SessionGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMessageLog_TextMessageProcessID] ON [dbo].[datClientMessageLog]
(
	[TextMessageProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMessageLog_TextMessageStatusID] ON [dbo].[datClientMessageLog]
(
	[TextMessageStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientMessageLog] ADD  CONSTRAINT [DF_datClientMessageLog_IsReprocessFlag]  DEFAULT ((0)) FOR [IsReprocessFlag]
GO
ALTER TABLE [dbo].[datClientMessageLog]  WITH CHECK ADD  CONSTRAINT [FK_datClientMessageLog_lkpTextMessageProcess] FOREIGN KEY([TextMessageProcessID])
REFERENCES [dbo].[lkpTextMessageProcess] ([TextMessageProcessID])
GO
ALTER TABLE [dbo].[datClientMessageLog] CHECK CONSTRAINT [FK_datClientMessageLog_lkpTextMessageProcess]
GO
ALTER TABLE [dbo].[datClientMessageLog]  WITH CHECK ADD  CONSTRAINT [FK_datClientMessageLog_lkpTextMessageStatus] FOREIGN KEY([TextMessageStatusID])
REFERENCES [dbo].[lkpTextMessageStatus] ([TextMessageStatusID])
GO
ALTER TABLE [dbo].[datClientMessageLog] CHECK CONSTRAINT [FK_datClientMessageLog_lkpTextMessageStatus]
GO
