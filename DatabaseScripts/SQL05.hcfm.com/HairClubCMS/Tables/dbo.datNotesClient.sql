/* CreateDate: 05/05/2020 17:42:51.340 , ModifyDate: 05/05/2020 18:34:08.627 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datNotesClient_AppointmentGUID] ON [dbo].[datNotesClient]
(
	[AppointmentGUID] ASC
)
INCLUDE([NotesClientDate],[NotesClient]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datNotesClient_HairSystemOrderGUID_INCL] ON [dbo].[datNotesClient]
(
	[HairSystemOrderGUID] ASC
)
INCLUDE([NoteTypeID],[NotesClient]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
