/* CreateDate: 06/10/2019 06:44:57.830 , ModifyDate: 06/10/2019 06:44:57.920 */
GO
CREATE TABLE [dbo].[datStyleBookClientFavorite](
	[StyleBookClientFavoriteID] [int] IDENTITY(1,1) NOT NULL,
	[StyleBookID] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datStyleBookClientFavorite] PRIMARY KEY CLUSTERED
(
	[StyleBookClientFavoriteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datStyleBookClientFavorite]  WITH NOCHECK ADD  CONSTRAINT [FK_datStyleBookClientFavorite_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datStyleBookClientFavorite] CHECK CONSTRAINT [FK_datStyleBookClientFavorite_datClient]
GO
ALTER TABLE [dbo].[datStyleBookClientFavorite]  WITH NOCHECK ADD  CONSTRAINT [FK_datStyleBookClientFavorite_datStyleBook] FOREIGN KEY([StyleBookID])
REFERENCES [dbo].[datStyleBook] ([StyleBookID])
GO
ALTER TABLE [dbo].[datStyleBookClientFavorite] CHECK CONSTRAINT [FK_datStyleBookClientFavorite_datStyleBook]
GO
