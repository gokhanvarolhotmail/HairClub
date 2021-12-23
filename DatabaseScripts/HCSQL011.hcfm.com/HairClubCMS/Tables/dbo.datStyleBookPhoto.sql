/* CreateDate: 06/10/2019 06:44:57.843 , ModifyDate: 06/10/2019 06:44:57.927 */
GO
CREATE TABLE [dbo].[datStyleBookPhoto](
	[StyleBookPhotoID] [int] IDENTITY(1,1) NOT NULL,
	[StyleBookID] [int] NOT NULL,
	[IsPrimaryPhoto] [bit] NOT NULL,
	[PhotoSortOrder] [int] NOT NULL,
	[PhotoDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhotoPath] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoSizeInBytes] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datStyleBookPhoto] PRIMARY KEY CLUSTERED
(
	[StyleBookPhotoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datStyleBookPhoto]  WITH NOCHECK ADD  CONSTRAINT [FK_datStyleBookPhoto_datStyleBook] FOREIGN KEY([StyleBookID])
REFERENCES [dbo].[datStyleBook] ([StyleBookID])
GO
ALTER TABLE [dbo].[datStyleBookPhoto] CHECK CONSTRAINT [FK_datStyleBookPhoto_datStyleBook]
GO
