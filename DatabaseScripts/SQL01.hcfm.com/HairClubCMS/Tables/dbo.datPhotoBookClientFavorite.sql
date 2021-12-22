CREATE TABLE [dbo].[datPhotoBookClientFavorite](
	[PhotoBookClientID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookID] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[SalesforceContactID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datPhotoBookClientFavorite] PRIMARY KEY CLUSTERED
(
	[PhotoBookClientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPhotoBookClientFavorite]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookClientFavorite_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datPhotoBookClientFavorite] CHECK CONSTRAINT [FK_datPhotoBookClientFavorite_datClient]
GO
ALTER TABLE [dbo].[datPhotoBookClientFavorite]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookClientFavorite_datPhotoBook] FOREIGN KEY([PhotoBookID])
REFERENCES [dbo].[datPhotoBook] ([PhotoBookID])
GO
ALTER TABLE [dbo].[datPhotoBookClientFavorite] CHECK CONSTRAINT [FK_datPhotoBookClientFavorite_datPhotoBook]
