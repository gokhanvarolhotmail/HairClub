CREATE TABLE [dbo].[datPhotoBookPhotoBookMDPType](
	[PhotoBookPhotoBookMDPTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookID] [int] NOT NULL,
	[PhotoBookMDPTypeID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datPhotoBookPhotoBookMDPType] PRIMARY KEY CLUSTERED
(
	[PhotoBookPhotoBookMDPTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookMDPType]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookPhotoBookMDPType_datPhotoBook] FOREIGN KEY([PhotoBookID])
REFERENCES [dbo].[datPhotoBook] ([PhotoBookID])
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookMDPType] CHECK CONSTRAINT [FK_datPhotoBookPhotoBookMDPType_datPhotoBook]
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookMDPType]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookPhotoBookMDPType_lkpPhotoBookMDPType] FOREIGN KEY([PhotoBookMDPTypeID])
REFERENCES [dbo].[lkpPhotoBookMDPType] ([PhotoBookMDPTypeID])
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookMDPType] CHECK CONSTRAINT [FK_datPhotoBookPhotoBookMDPType_lkpPhotoBookMDPType]
