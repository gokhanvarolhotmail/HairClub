/* CreateDate: 09/09/2016 10:26:19.070 , ModifyDate: 12/18/2017 20:34:54.613 */
GO
CREATE TABLE [dbo].[datLeadMessageLog](
	[LeadMessageLogID] [int] IDENTITY(1,1) NOT NULL,
	[TextMessageProcessID] [int] NOT NULL,
	[SessionGUID] [uniqueidentifier] NOT NULL,
	[BatchID] [int] NOT NULL,
	[ContactID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FirstName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActivityID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActivityDate] [datetime] NOT NULL,
	[ActivityDateUTC] [datetime] NOT NULL,
	[PhoneNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LanguageCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CenterID] [int] NOT NULL,
	[CenterName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AddressLine1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[AddressLine2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[City] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StateCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CountryCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TextMessage] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TextMessageStatusID] [int] NOT NULL,
	[ErrorCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorVerbiage] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsReprocessFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_datLeadMessageLog] PRIMARY KEY CLUSTERED
(
	[LeadMessageLogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datLeadMessageLog_ActivityID] ON [dbo].[datLeadMessageLog]
(
	[ActivityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datLeadMessageLog_BatchID] ON [dbo].[datLeadMessageLog]
(
	[BatchID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_datLeadMessageLog_ContactID] ON [dbo].[datLeadMessageLog]
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datLeadMessageLog_IsReprocessFlag] ON [dbo].[datLeadMessageLog]
(
	[IsReprocessFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datLeadMessageLog_SessionGUID] ON [dbo].[datLeadMessageLog]
(
	[SessionGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datLeadMessageLog_TextMessageProcessID] ON [dbo].[datLeadMessageLog]
(
	[TextMessageProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datLeadMessageLog_TextMessageStatusID] ON [dbo].[datLeadMessageLog]
(
	[TextMessageStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datLeadMessageLog] ADD  CONSTRAINT [DF_datLeadMessageLog_IsReprocessFlag]  DEFAULT ((0)) FOR [IsReprocessFlag]
GO
ALTER TABLE [dbo].[datLeadMessageLog]  WITH CHECK ADD  CONSTRAINT [FK_datLeadMessageLog_lkpTextMessageProcess] FOREIGN KEY([TextMessageProcessID])
REFERENCES [dbo].[lkpTextMessageProcess] ([TextMessageProcessID])
GO
ALTER TABLE [dbo].[datLeadMessageLog] CHECK CONSTRAINT [FK_datLeadMessageLog_lkpTextMessageProcess]
GO
ALTER TABLE [dbo].[datLeadMessageLog]  WITH CHECK ADD  CONSTRAINT [FK_datLeadMessageLog_lkpTextMessageStatus] FOREIGN KEY([TextMessageStatusID])
REFERENCES [dbo].[lkpTextMessageStatus] ([TextMessageStatusID])
GO
ALTER TABLE [dbo].[datLeadMessageLog] CHECK CONSTRAINT [FK_datLeadMessageLog_lkpTextMessageStatus]
GO
