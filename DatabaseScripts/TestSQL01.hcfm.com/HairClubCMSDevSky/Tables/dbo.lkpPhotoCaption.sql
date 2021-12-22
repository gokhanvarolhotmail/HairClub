/* CreateDate: 10/04/2010 12:00:48.590 , ModifyDate: 12/07/2021 16:20:15.923 */
GO
CREATE TABLE [dbo].[lkpPhotoCaption](
	[PhotoCaptionID] [int] NOT NULL,
	[PhotoCaptionSortOrder] [int] NULL,
	[PhotoCaptionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoCaptionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BusinessSegmentID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[HelpText] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpPhotoCaption] PRIMARY KEY CLUSTERED
(
	[PhotoCaptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpPhotoCaption] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpPhotoCaption]  WITH CHECK ADD  CONSTRAINT [FK_lkpPhotoCaption_lkpBusinessSegment] FOREIGN KEY([BusinessSegmentID])
REFERENCES [dbo].[lkpBusinessSegment] ([BusinessSegmentID])
GO
ALTER TABLE [dbo].[lkpPhotoCaption] CHECK CONSTRAINT [FK_lkpPhotoCaption_lkpBusinessSegment]
GO
