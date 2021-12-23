/* CreateDate: 06/05/2017 06:22:02.983 , ModifyDate: 06/05/2017 06:22:03.033 */
GO
CREATE TABLE [dbo].[datPhotoBookPhotoBookSurgeryType](
	[PhotoBookPhotoBookSurgeryTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookID] [int] NOT NULL,
	[PhotoBookSurgeryTypeID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datPhotoBookPhotoBookSurgeryType] PRIMARY KEY CLUSTERED
(
	[PhotoBookPhotoBookSurgeryTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookSurgeryType]  WITH NOCHECK ADD  CONSTRAINT [FK_datPhotoBookPhotoBookSurgeryType_datPhotoBook] FOREIGN KEY([PhotoBookID])
REFERENCES [dbo].[datPhotoBook] ([PhotoBookID])
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookSurgeryType] CHECK CONSTRAINT [FK_datPhotoBookPhotoBookSurgeryType_datPhotoBook]
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookSurgeryType]  WITH NOCHECK ADD  CONSTRAINT [FK_datPhotoBookPhotoBookSurgeryType_lkpPhotoBookSurgeryType] FOREIGN KEY([PhotoBookSurgeryTypeID])
REFERENCES [dbo].[lkpPhotoBookSurgeryType] ([PhotoBookSurgeryTypeID])
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookSurgeryType] CHECK CONSTRAINT [FK_datPhotoBookPhotoBookSurgeryType_lkpPhotoBookSurgeryType]
GO
