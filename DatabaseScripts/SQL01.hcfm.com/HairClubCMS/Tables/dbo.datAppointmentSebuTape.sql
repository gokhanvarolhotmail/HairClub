CREATE TABLE [dbo].[datAppointmentSebuTape](
	[AppointmentSebuTapeID] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[SebuTapeLevelID] [int] NOT NULL,
	[ScalpRegionID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datAppointmentSebuTape] PRIMARY KEY CLUSTERED
(
	[AppointmentSebuTapeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UK_datAppointmentSebuTape_AppointmentGUID_ScalpRegionID] UNIQUE NONCLUSTERED
(
	[AppointmentGUID] ASC,
	[ScalpRegionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAppointmentSebuTape]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentSebuTape_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datAppointmentSebuTape] CHECK CONSTRAINT [FK_datAppointmentSebuTape_datAppointment]
GO
ALTER TABLE [dbo].[datAppointmentSebuTape]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentSebuTape_lkpScalpRegion] FOREIGN KEY([ScalpRegionID])
REFERENCES [dbo].[lkpScalpRegion] ([ScalpRegionID])
GO
ALTER TABLE [dbo].[datAppointmentSebuTape] CHECK CONSTRAINT [FK_datAppointmentSebuTape_lkpScalpRegion]
GO
ALTER TABLE [dbo].[datAppointmentSebuTape]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentSebuTape_lkpSebuTapeLevel] FOREIGN KEY([SebuTapeLevelID])
REFERENCES [dbo].[lkpSebuTapeLevel] ([SebuTapeLevelID])
GO
ALTER TABLE [dbo].[datAppointmentSebuTape] CHECK CONSTRAINT [FK_datAppointmentSebuTape_lkpSebuTapeLevel]
