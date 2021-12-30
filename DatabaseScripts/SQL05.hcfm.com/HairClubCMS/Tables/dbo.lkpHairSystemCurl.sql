/* CreateDate: 05/05/2020 17:42:42.010 , ModifyDate: 05/05/2020 18:41:06.607 */
GO
CREATE TABLE [dbo].[lkpHairSystemCurl](
	[HairSystemCurlID] [int] NOT NULL,
	[HairSystemCurlSortOrder] [int] NOT NULL,
	[HairSystemCurlDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemCurlDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HumanHairLengthMinimum] [int] NULL,
	[HumanHairLengthMaximum] [int] NULL,
	[SyntheticHairLengthMinimum] [int] NULL,
	[SyntheticHairLengthMaximum] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsAllowHumanGreyPercentageFlag] [bit] NOT NULL,
	[IsAllowSyntheticGreyPercentageFlag] [bit] NOT NULL,
	[HairSystemCurlGroupID] [int] NOT NULL,
	[IsCuticleIntactAvailableFlag] [bit] NOT NULL,
	[IsRootShadowingAvailableFlag] [bit] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemCurl] PRIMARY KEY CLUSTERED
(
	[HairSystemCurlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
