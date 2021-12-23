/* CreateDate: 05/21/2017 22:29:11.000 , ModifyDate: 05/21/2017 22:29:11.060 */
GO
CREATE TABLE [dbo].[datPhotoBookNorwoodScale](
	[PhotoBookNorwoodScaleID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookID] [int] NOT NULL,
	[NorwoodScaleID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datPhotoBookNorwoodScale] PRIMARY KEY CLUSTERED
(
	[PhotoBookNorwoodScaleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPhotoBookNorwoodScale]  WITH NOCHECK ADD  CONSTRAINT [FK_datPhotoBookNorwoodScale_datPhotoBook] FOREIGN KEY([PhotoBookID])
REFERENCES [dbo].[datPhotoBook] ([PhotoBookID])
GO
ALTER TABLE [dbo].[datPhotoBookNorwoodScale] CHECK CONSTRAINT [FK_datPhotoBookNorwoodScale_datPhotoBook]
GO
ALTER TABLE [dbo].[datPhotoBookNorwoodScale]  WITH NOCHECK ADD  CONSTRAINT [FK_datPhotoBookNorwoodScale_lkpNorwoodScale] FOREIGN KEY([NorwoodScaleID])
REFERENCES [dbo].[lkpNorwoodScale] ([NorwoodScaleID])
GO
ALTER TABLE [dbo].[datPhotoBookNorwoodScale] CHECK CONSTRAINT [FK_datPhotoBookNorwoodScale_lkpNorwoodScale]
GO
