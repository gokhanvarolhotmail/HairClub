/* CreateDate: 05/21/2017 22:29:10.903 , ModifyDate: 05/21/2017 22:29:10.957 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datPhotoBookLudwigScale](
	[PhotoBookLudwigScaleID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookID] [int] NOT NULL,
	[LudwigScaleID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datPhotoBookLudwigScale] PRIMARY KEY CLUSTERED
(
	[PhotoBookLudwigScaleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPhotoBookLudwigScale]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookLudwigScale_datPhotoBook] FOREIGN KEY([PhotoBookID])
REFERENCES [dbo].[datPhotoBook] ([PhotoBookID])
GO
ALTER TABLE [dbo].[datPhotoBookLudwigScale] CHECK CONSTRAINT [FK_datPhotoBookLudwigScale_datPhotoBook]
GO
ALTER TABLE [dbo].[datPhotoBookLudwigScale]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookLudwigScale_lkpLudwigScale] FOREIGN KEY([LudwigScaleID])
REFERENCES [dbo].[lkpLudwigScale] ([LudwigScaleID])
GO
ALTER TABLE [dbo].[datPhotoBookLudwigScale] CHECK CONSTRAINT [FK_datPhotoBookLudwigScale_lkpLudwigScale]
GO
