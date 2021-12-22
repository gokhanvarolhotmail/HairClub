/* CreateDate: 05/21/2017 22:29:10.640 , ModifyDate: 07/13/2018 05:40:42.700 */
GO
CREATE TABLE [dbo].[datPhotoBookPhotoSet](
	[PhotoBookPhotoSetID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookID] [int] NOT NULL,
	[IsPrimaryPhotoSet] [bit] NOT NULL,
	[PhotoBeforePath] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoBeforeSizeInBytes] [int] NOT NULL,
	[PhotoAfterPath] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoAfterSizeInBytes] [int] NOT NULL,
	[PhotoSetSortOrder] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[PhotoBeforeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhotoAfterDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datPhotoBookPhotoSet] PRIMARY KEY CLUSTERED
(
	[PhotoBookPhotoSetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPhotoBookPhotoSet]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookPhotoSet_datPhotoBook] FOREIGN KEY([PhotoBookID])
REFERENCES [dbo].[datPhotoBook] ([PhotoBookID])
GO
ALTER TABLE [dbo].[datPhotoBookPhotoSet] CHECK CONSTRAINT [FK_datPhotoBookPhotoSet_datPhotoBook]
GO
