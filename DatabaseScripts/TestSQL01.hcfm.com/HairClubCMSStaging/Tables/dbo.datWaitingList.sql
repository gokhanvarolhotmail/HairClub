/* CreateDate: 06/11/2014 08:04:32.290 , ModifyDate: 02/04/2022 21:16:04.947 */
GO
CREATE TABLE [dbo].[datWaitingList](
	[WaitingListID] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[StartTime] [time](7) NOT NULL,
	[EndDate] [datetime] NOT NULL,
	[EndTime] [time](7) NOT NULL,
	[IsDeletedFlag] [bit] NOT NULL,
	[MinimumDuration] [int] NOT NULL,
	[WaitingListPriorityID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datWaitingList] PRIMARY KEY CLUSTERED
(
	[WaitingListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datWaitingList_AppointmentGUID_ClientGUID_StartDate_EndDate_IsDeleted] ON [dbo].[datWaitingList]
(
	[AppointmentGUID] ASC,
	[ClientGUID] ASC,
	[StartDate] ASC,
	[EndDate] ASC,
	[IsDeletedFlag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datWaitingList_ClientGUID] ON [dbo].[datWaitingList]
(
	[CenterID] ASC,
	[ClientGUID] ASC,
	[StartDate] ASC,
	[EndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datWaitingList]  WITH CHECK ADD  CONSTRAINT [FK_datWaitingList_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datWaitingList] CHECK CONSTRAINT [FK_datWaitingList_cfgCenter]
GO
ALTER TABLE [dbo].[datWaitingList]  WITH CHECK ADD  CONSTRAINT [FK_datWaitingList_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datWaitingList] CHECK CONSTRAINT [FK_datWaitingList_datAppointment]
GO
ALTER TABLE [dbo].[datWaitingList]  WITH CHECK ADD  CONSTRAINT [FK_datWaitingList_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datWaitingList] CHECK CONSTRAINT [FK_datWaitingList_datClient]
GO
ALTER TABLE [dbo].[datWaitingList]  WITH CHECK ADD  CONSTRAINT [FK_datWaitingList_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datWaitingList] CHECK CONSTRAINT [FK_datWaitingList_datClientMembership]
GO
ALTER TABLE [dbo].[datWaitingList]  WITH CHECK ADD  CONSTRAINT [FK_datWaitingList_LkpWaitingListPriority] FOREIGN KEY([WaitingListPriorityID])
REFERENCES [dbo].[lkpWaitingListPriority] ([WaitingListPriorityID])
GO
ALTER TABLE [dbo].[datWaitingList] CHECK CONSTRAINT [FK_datWaitingList_LkpWaitingListPriority]
GO
