CREATE TABLE [dbo].[ImageSizes3](
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[CenterID] [int] NULL,
	[AppointmentPhotoGUID] [uniqueidentifier] NOT NULL,
	[AppointmentPhotoLen] [bigint] NULL,
	[AppointmentPhotoModifiedLen] [bigint] NULL
) ON [PRIMARY]
