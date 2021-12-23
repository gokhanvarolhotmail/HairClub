/* CreateDate: 10/28/2008 15:22:20.733 , ModifyDate: 12/07/2021 16:20:15.870 */
GO
CREATE TABLE [dbo].[datNotesClient](
	[NotesClientGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[EmployeeGUID] [uniqueidentifier] NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[NoteTypeID] [int] NULL,
	[NotesClientDate] [datetime] NULL,
	[NotesClient] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[HairSystemOrderGUID] [uniqueidentifier] NULL,
	[NoteSubTypeID] [int] NULL,
	[IsFlagged] [bit] NOT NULL,
	[ScorecardCategoryID] [int] NULL,
 CONSTRAINT [PK_datNotesClient] PRIMARY KEY CLUSTERED
(
	[NotesClientGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNotesClient_AppointmentGUID] ON [dbo].[datNotesClient]
(
	[AppointmentGUID] ASC
)
INCLUDE([NoteTypeID],[NotesClient]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNotesClient_ClientGUID] ON [dbo].[datNotesClient]
(
	[ClientGUID] ASC,
	[IsFlagged] ASC
)
INCLUDE([NoteTypeID],[NoteSubTypeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNotesClient_HairSystemOrderGUID] ON [dbo].[datNotesClient]
(
	[HairSystemOrderGUID] ASC
)
INCLUDE([NotesClientGUID],[ClientGUID],[EmployeeGUID],[AppointmentGUID],[SalesOrderGUID],[ClientMembershipGUID],[NoteTypeID],[NotesClientDate],[NotesClient],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[UpdateStamp]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNotesClient_SalesOrderGuid] ON [dbo].[datNotesClient]
(
	[SalesOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datNotesClient] ADD  DEFAULT ((0)) FOR [IsFlagged]
GO
ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_datAppointment]
GO
ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_datClient]
GO
ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_datClientMembership]
GO
ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_datEmployee] FOREIGN KEY([EmployeeGUID])
REFERENCES [dbo].[datEmployee] ([EmployeeGUID])
GO
ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_datEmployee]
GO
ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_datHairSystemOrder] FOREIGN KEY([HairSystemOrderGUID])
REFERENCES [dbo].[datHairSystemOrder] ([HairSystemOrderGUID])
GO
ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_datHairSystemOrder]
GO
ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_datSalesOrder] FOREIGN KEY([SalesOrderGUID])
REFERENCES [dbo].[datSalesOrder] ([SalesOrderGUID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_datSalesOrder]
GO
ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_lkpNoteSubType] FOREIGN KEY([NoteSubTypeID])
REFERENCES [dbo].[lkpNoteSubType] ([NoteSubTypeID])
GO
ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_lkpNoteSubType]
GO
ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_lkpNoteType] FOREIGN KEY([NoteTypeID])
REFERENCES [dbo].[lkpNoteType] ([NoteTypeID])
GO
ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_lkpNoteType]
GO
ALTER TABLE [dbo].[datNotesClient]  WITH CHECK ADD  CONSTRAINT [FK_datNotesClient_lkpScorecardCategory] FOREIGN KEY([ScorecardCategoryID])
REFERENCES [dbo].[lkpScorecardCategory] ([ScorecardCategoryID])
GO
ALTER TABLE [dbo].[datNotesClient] CHECK CONSTRAINT [FK_datNotesClient_lkpScorecardCategory]
GO
