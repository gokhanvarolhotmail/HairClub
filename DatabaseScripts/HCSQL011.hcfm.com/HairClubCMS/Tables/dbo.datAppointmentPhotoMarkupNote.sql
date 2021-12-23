/* CreateDate: 08/05/2014 08:15:50.620 , ModifyDate: 10/29/2015 22:40:20.973 */
GO
CREATE TABLE [dbo].[datAppointmentPhotoMarkupNote](
	[AppointmentPhotoMarkupNoteID] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentPhotoMarkupID] [int] NOT NULL,
	[ObservationNote] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SebumLevelID] [int] NULL,
	[FlakingLevelID] [int] NULL,
	[SorenessLevelID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datAppointmentPhotoMarkupNote] PRIMARY KEY CLUSTERED
(
	[AppointmentPhotoMarkupNoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [UK_datAppointmentPhotoMarkupNote_AppointmentPhotoMarkupID] ON [dbo].[datAppointmentPhotoMarkupNote]
(
	[AppointmentPhotoMarkupID] DESC
)
INCLUDE([AppointmentPhotoMarkupNoteID],[ObservationNote],[SebumLevelID],[FlakingLevelID],[SorenessLevelID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkupNote]  WITH NOCHECK ADD  CONSTRAINT [FK_datAppointmentPhotoMarkupNote_datAppointmentPhotoMarkup] FOREIGN KEY([AppointmentPhotoMarkupID])
REFERENCES [dbo].[datAppointmentPhotoMarkup] ([AppointmentPhotoMarkupID])
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkupNote] CHECK CONSTRAINT [FK_datAppointmentPhotoMarkupNote_datAppointmentPhotoMarkup]
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkupNote]  WITH NOCHECK ADD  CONSTRAINT [FK_datAppointmentPhotoMarkupNote_lkpFlakingLevel] FOREIGN KEY([FlakingLevelID])
REFERENCES [dbo].[lkpFlakingLevel] ([FlakingLevelID])
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkupNote] CHECK CONSTRAINT [FK_datAppointmentPhotoMarkupNote_lkpFlakingLevel]
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkupNote]  WITH NOCHECK ADD  CONSTRAINT [FK_datAppointmentPhotoMarkupNote_lkpSebumLevel] FOREIGN KEY([SebumLevelID])
REFERENCES [dbo].[lkpSebumLevel] ([SebumLevelID])
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkupNote] CHECK CONSTRAINT [FK_datAppointmentPhotoMarkupNote_lkpSebumLevel]
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkupNote]  WITH NOCHECK ADD  CONSTRAINT [FK_datAppointmentPhotoMarkupNote_lkpSorenessLevel] FOREIGN KEY([SorenessLevelID])
REFERENCES [dbo].[lkpSorenessLevel] ([SorenessLevelID])
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkupNote] CHECK CONSTRAINT [FK_datAppointmentPhotoMarkupNote_lkpSorenessLevel]
GO
