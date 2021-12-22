/* CreateDate: 11/04/2019 10:11:46.740 , ModifyDate: 11/04/2019 10:11:46.740 */
GO
CREATE TABLE [dbo].[lkpHairSystemHairCap](
	[HairSystemHairCapID] [int] NOT NULL,
	[HairSystemHairCapSortOrder] [int] NOT NULL,
	[HairSystemHairCapDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHairCapDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairCapMinimumArea] [decimal](23, 8) NOT NULL,
	[HairCapMaximumArea] [decimal](23, 8) NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NOT NULL
) ON [PRIMARY]
GO
