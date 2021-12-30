/* CreateDate: 10/04/2010 12:08:46.277 , ModifyDate: 12/29/2021 15:38:46.383 */
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
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemHairCap] PRIMARY KEY CLUSTERED
(
	[HairSystemHairCapID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
