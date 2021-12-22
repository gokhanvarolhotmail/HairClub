/* CreateDate: 05/06/2014 09:10:03.240 , ModifyDate: 12/22/2020 20:22:55.177 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datAppointmentPhoto](
	[AppointmentPhotoID] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentPhotoGUID] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[PhotoTypeID] [int] NOT NULL,
	[PhotoCaptionID] [int] NULL,
	[PhotoCaptionOverride] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentPhoto] [varbinary](max) FILESTREAM  NOT NULL,
	[AppointmentPhotoModified] [varbinary](max) FILESTREAM  NULL,
	[ScalpAreaID] [int] NULL,
	[ScalpRegionID] [int] NULL,
	[PhotoLensID] [int] NOT NULL,
	[PhotoLightTypeID] [int] NOT NULL,
	[ComparisonSet] [int] NULL,
	[PhotoSizeInBytes] [int] NOT NULL,
	[Camera] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Quality] [int] NOT NULL,
	[MimeType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[SequenceOrder] [int] NULL,
	[NoteForClient] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DensityInMMSquared] [decimal](18, 2) NULL,
	[DiameterInMicrons] [decimal](18, 2) NULL,
	[AverageWidth] [decimal](18, 2) NULL,
 CONSTRAINT [PK_datAppointmentPhoto] PRIMARY KEY CLUSTERED
(
	[AppointmentPhotoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] FILESTREAM_ON [HCCMSFileStreamClientPics],
 CONSTRAINT [UQ__datAppoi__0BA5B3F954A763E3] UNIQUE NONCLUSTERED
(
	[AppointmentPhotoGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] FILESTREAM_ON [HCCMSFileStreamClientPics]
GO
CREATE NONCLUSTERED INDEX [IX_datAppointmentPhoto_AppointmentGUID] ON [dbo].[datAppointmentPhoto]
(
	[AppointmentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datAppointmentPhoto] ADD  CONSTRAINT [DF_datAppointmentPhoto_DensityInMMSquared]  DEFAULT ((0)) FOR [DensityInMMSquared]
GO
ALTER TABLE [dbo].[datAppointmentPhoto] ADD  CONSTRAINT [DF_datAppointmentPhoto_DiameterInMicrons]  DEFAULT ((0)) FOR [DiameterInMicrons]
GO
ALTER TABLE [dbo].[datAppointmentPhoto] ADD  CONSTRAINT [DF_datAppointmentPhoto_AverageWidth]  DEFAULT ((0)) FOR [AverageWidth]
GO
ALTER TABLE [dbo].[datAppointmentPhoto]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhoto_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[datAppointmentPhoto] CHECK CONSTRAINT [FK_datAppointmentPhoto_datAppointment]
GO
ALTER TABLE [dbo].[datAppointmentPhoto]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhoto_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datAppointmentPhoto] CHECK CONSTRAINT [FK_datAppointmentPhoto_datClient]
GO
ALTER TABLE [dbo].[datAppointmentPhoto]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhoto_lkpPhotoCaption] FOREIGN KEY([PhotoCaptionID])
REFERENCES [dbo].[lkpPhotoCaption] ([PhotoCaptionID])
GO
ALTER TABLE [dbo].[datAppointmentPhoto] CHECK CONSTRAINT [FK_datAppointmentPhoto_lkpPhotoCaption]
GO
ALTER TABLE [dbo].[datAppointmentPhoto]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhoto_lkpPhotoLens] FOREIGN KEY([PhotoLensID])
REFERENCES [dbo].[lkpPhotoLens] ([PhotoLensID])
GO
ALTER TABLE [dbo].[datAppointmentPhoto] CHECK CONSTRAINT [FK_datAppointmentPhoto_lkpPhotoLens]
GO
ALTER TABLE [dbo].[datAppointmentPhoto]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhoto_lkpPhotoLightType] FOREIGN KEY([PhotoLightTypeID])
REFERENCES [dbo].[lkpPhotoLightType] ([PhotoLightTypeID])
GO
ALTER TABLE [dbo].[datAppointmentPhoto] CHECK CONSTRAINT [FK_datAppointmentPhoto_lkpPhotoLightType]
GO
ALTER TABLE [dbo].[datAppointmentPhoto]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhoto_lkpPhotoType] FOREIGN KEY([PhotoTypeID])
REFERENCES [dbo].[lkpPhotoType] ([PhotoTypeID])
GO
ALTER TABLE [dbo].[datAppointmentPhoto] CHECK CONSTRAINT [FK_datAppointmentPhoto_lkpPhotoType]
GO
ALTER TABLE [dbo].[datAppointmentPhoto]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhoto_lkpScalpArea] FOREIGN KEY([ScalpAreaID])
REFERENCES [dbo].[lkpScalpArea] ([ScalpAreaID])
GO
ALTER TABLE [dbo].[datAppointmentPhoto] CHECK CONSTRAINT [FK_datAppointmentPhoto_lkpScalpArea]
GO
ALTER TABLE [dbo].[datAppointmentPhoto]  WITH CHECK ADD  CONSTRAINT [FK_datAppointmentPhoto_lkpScalpRegion] FOREIGN KEY([ScalpRegionID])
REFERENCES [dbo].[lkpScalpRegion] ([ScalpRegionID])
GO
ALTER TABLE [dbo].[datAppointmentPhoto] CHECK CONSTRAINT [FK_datAppointmentPhoto_lkpScalpRegion]
GO
