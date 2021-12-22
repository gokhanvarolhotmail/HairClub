CREATE TABLE [dbo].[datPhotoBook](
	[PhotoBookID] [int] IDENTITY(1,1) NOT NULL,
	[BusinessSegmentID] [int] NOT NULL,
	[GenderID] [int] NOT NULL,
	[CenterID] [int] NULL,
	[PhotoBookDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[PhotoBookSortOrder] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsTimelineView] [bit] NOT NULL,
	[Disclaimer] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsHaloAndExtensionsPhotoBook] [bit] NOT NULL,
 CONSTRAINT [PK_datPhotoBook] PRIMARY KEY CLUSTERED
(
	[PhotoBookID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPhotoBook]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBook_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[datPhotoBook] CHECK CONSTRAINT [FK_datPhotoBook_cfgCenter]
GO
ALTER TABLE [dbo].[datPhotoBook]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBook_lkpBusinessSegment] FOREIGN KEY([BusinessSegmentID])
REFERENCES [dbo].[lkpBusinessSegment] ([BusinessSegmentID])
GO
ALTER TABLE [dbo].[datPhotoBook] CHECK CONSTRAINT [FK_datPhotoBook_lkpBusinessSegment]
GO
ALTER TABLE [dbo].[datPhotoBook]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBook_lkpGender] FOREIGN KEY([GenderID])
REFERENCES [dbo].[lkpGender] ([GenderID])
GO
ALTER TABLE [dbo].[datPhotoBook] CHECK CONSTRAINT [FK_datPhotoBook_lkpGender]
