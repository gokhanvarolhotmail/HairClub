CREATE TABLE [dbo].[datClientPhoto](
	[ClientPhotoID] [int] IDENTITY(1,1) NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[Height] [int] NOT NULL,
	[Width] [int] NOT NULL,
	[ClientPhoto] [varbinary](max) NOT NULL,
	[PhotoSizeInBytes] [int] NOT NULL,
	[Camera] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Quality] [int] NOT NULL,
	[MimeType] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientPhoto] PRIMARY KEY CLUSTERED
(
	[ClientPhotoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientPhoto]  WITH CHECK ADD  CONSTRAINT [FK_datClientPhoto_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientPhoto] CHECK CONSTRAINT [FK_datClientPhoto_datClient]
