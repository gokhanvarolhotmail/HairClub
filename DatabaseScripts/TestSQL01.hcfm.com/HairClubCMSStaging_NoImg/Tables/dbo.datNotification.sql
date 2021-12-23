/* CreateDate: 05/14/2012 17:33:38.163 , ModifyDate: 12/03/2021 10:24:48.733 */
GO
CREATE TABLE [dbo].[datNotification](
	[NotificationID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NotificationDate] [datetime] NOT NULL,
	[NotificationTypeID] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[FeePayCycleID] [int] NULL,
	[FeeDate] [date] NULL,
	[CenterID] [int] NOT NULL,
	[IsAcknowledgedFlag] [bit] NOT NULL,
	[Description] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[IsHairOrderRequestedFlag] [bit] NOT NULL,
	[VisitingCenterID] [int] NULL,
 CONSTRAINT [PK_datNotification] PRIMARY KEY CLUSTERED
(
	[NotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNotification_AppointmentGUID] ON [dbo].[datNotification]
(
	[AppointmentGUID] ASC
)
INCLUDE([NotificationDate],[NotificationTypeID],[ClientGUID],[FeePayCycleID],[FeeDate],[CenterID],[IsAcknowledgedFlag],[Description],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp],[IsHairOrderRequestedFlag],[VisitingCenterID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNotification_CenterID_IsAcknowledgedFlag] ON [dbo].[datNotification]
(
	[CenterID] ASC,
	[IsAcknowledgedFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNotification_IsAcknowledgedFlag_VisitingCenterID] ON [dbo].[datNotification]
(
	[IsAcknowledgedFlag] ASC,
	[VisitingCenterID] ASC
)
INCLUDE([NotificationTypeID],[ClientGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datNotification] ADD  DEFAULT ((0)) FOR [IsHairOrderRequestedFlag]
GO
ALTER TABLE [dbo].[datNotification]  WITH NOCHECK ADD  CONSTRAINT [FK_datNotification_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datNotification] CHECK CONSTRAINT [FK_datNotification_cfgCenter]
GO
ALTER TABLE [dbo].[datNotification]  WITH NOCHECK ADD  CONSTRAINT [FK_datNotification_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datNotification] CHECK CONSTRAINT [FK_datNotification_datAppointment]
GO
ALTER TABLE [dbo].[datNotification]  WITH NOCHECK ADD  CONSTRAINT [FK_datNotification_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datNotification] CHECK CONSTRAINT [FK_datNotification_datClient]
GO
ALTER TABLE [dbo].[datNotification]  WITH NOCHECK ADD  CONSTRAINT [FK_datNotification_lkpFeePayCycle] FOREIGN KEY([FeePayCycleID])
REFERENCES [dbo].[lkpFeePayCycle] ([FeePayCycleID])
GO
ALTER TABLE [dbo].[datNotification] CHECK CONSTRAINT [FK_datNotification_lkpFeePayCycle]
GO
ALTER TABLE [dbo].[datNotification]  WITH NOCHECK ADD  CONSTRAINT [FK_datNotification_lkpNotificationType] FOREIGN KEY([NotificationTypeID])
REFERENCES [dbo].[lkpNotificationType] ([NotificationTypeID])
GO
ALTER TABLE [dbo].[datNotification] CHECK CONSTRAINT [FK_datNotification_lkpNotificationType]
GO
ALTER TABLE [dbo].[datNotification]  WITH NOCHECK ADD  CONSTRAINT [FK_datNotification_VisitingCenterID] FOREIGN KEY([VisitingCenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datNotification] CHECK CONSTRAINT [FK_datNotification_VisitingCenterID]
GO
