/* CreateDate: 05/05/2020 17:42:41.827 , ModifyDate: 05/05/2020 18:41:07.230 */
GO
CREATE TABLE [dbo].[lkpHairSystemHairColor](
	[HairSystemHairColorID] [int] NOT NULL,
	[HairSystemHairColorSortOrder] [int] NOT NULL,
	[HairSystemHairColorDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHairColorDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsHairSampleFlag] [bit] NOT NULL,
	[HairSystemHairColorGroupID] [int] NOT NULL,
	[IsAvailableForOmbreOnlyFlag] [bit] NOT NULL,
	[IsCuticleIntactColor] [bit] NOT NULL,
	[IsRootShadowingColor] [bit] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemHairColor] PRIMARY KEY CLUSTERED
(
	[HairSystemHairColorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO