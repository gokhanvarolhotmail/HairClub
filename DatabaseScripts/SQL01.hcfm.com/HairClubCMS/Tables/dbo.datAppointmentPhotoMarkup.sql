CREATE TABLE [dbo].[datAppointmentPhotoMarkup](
	[AppointmentPhotoMarkupID] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentPhotoID] [int] NOT NULL,
	[PhotoMarkupTypeID] [int] NOT NULL,
	[PhotoMarkupImageTypeID] [int] NULL,
	[StrokeColor] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StrokeThickness] [decimal](18, 6) NULL,
	[FillColor] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DataPath] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Rotation] [decimal](18, 6) NULL,
	[PointX] [decimal](18, 6) NOT NULL,
	[PointY] [decimal](18, 6) NOT NULL,
	[Distance] [decimal](18, 6) NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[SequenceOrder] [int] NOT NULL,
	[PointX2] [decimal](18, 6) NULL,
	[PointY2] [decimal](18, 6) NULL,
	[Scale] [decimal](18, 6) NULL,
	[Opacity] [decimal](18, 6) NULL,
 CONSTRAINT [PK_datAppointmentPhotoMarkup] PRIMARY KEY CLUSTERED
(
	[AppointmentPhotoMarkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointmentPhotoMarkup_AppointmentPhotoID] ON [dbo].[datAppointmentPhotoMarkup]
(
	[AppointmentPhotoID] ASC
)
INCLUDE([AppointmentPhotoMarkupID],[Rotation],[Distance]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkup] ADD  CONSTRAINT [DF_datAppointmentPhotoMarkup_SequenceOrder]  DEFAULT ((0)) FOR [SequenceOrder]
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkup]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhotoMarkup_datAppointmentPhoto] FOREIGN KEY([AppointmentPhotoID])
REFERENCES [dbo].[datAppointmentPhoto] ([AppointmentPhotoID])
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkup] CHECK CONSTRAINT [FK_datAppointmentPhotoMarkup_datAppointmentPhoto]
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkup]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhotoMarkup_lkpPhotoMarkupImageType] FOREIGN KEY([PhotoMarkupImageTypeID])
REFERENCES [dbo].[lkpPhotoMarkupImageType] ([PhotoMarkupImageTypeID])
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkup] CHECK CONSTRAINT [FK_datAppointmentPhotoMarkup_lkpPhotoMarkupImageType]
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkup]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhotoMarkup_lkpPhotoMarkupType] FOREIGN KEY([PhotoMarkupTypeID])
REFERENCES [dbo].[lkpPhotoMarkupType] ([PhotoMarkupTypeID])
GO
ALTER TABLE [dbo].[datAppointmentPhotoMarkup] CHECK CONSTRAINT [FK_datAppointmentPhotoMarkup_lkpPhotoMarkupType]
