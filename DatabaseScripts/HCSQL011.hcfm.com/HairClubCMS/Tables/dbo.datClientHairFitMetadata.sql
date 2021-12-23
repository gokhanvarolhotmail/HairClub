/* CreateDate: 10/07/2019 14:04:05.427 , ModifyDate: 12/04/2019 14:47:03.133 */
GO
CREATE TABLE [dbo].[datClientHairFitMetadata](
	[ClientHairFitMetadataID] [int] IDENTITY(1,1) NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[HairFitStartDate] [datetime] NOT NULL,
	[LastLogin] [datetime] NOT NULL,
	[ClientObjectID] [nvarchar](36) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DevicePlatform] [nvarchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[AppVersion] [nvarchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datClientHairFitMetadata] PRIMARY KEY CLUSTERED
(
	[ClientHairFitMetadataID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientHairFitMetadata]  WITH NOCHECK ADD  CONSTRAINT [FK_datClientHairFitMetadata_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientHairFitMetadata] CHECK CONSTRAINT [FK_datClientHairFitMetadata_datClient]
GO
