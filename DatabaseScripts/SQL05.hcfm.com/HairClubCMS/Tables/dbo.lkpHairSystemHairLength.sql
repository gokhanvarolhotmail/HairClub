/* CreateDate: 05/05/2020 17:42:42.290 , ModifyDate: 05/05/2020 18:41:05.647 */
GO
CREATE TABLE [dbo].[lkpHairSystemHairLength](
	[HairSystemHairLengthID] [int] NOT NULL,
	[HairSystemHairLengthSortOrder] [int] NOT NULL,
	[HairSystemHairLengthDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHairLengthDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHairLengthValue] [int] NOT NULL,
	[IsHumanHairAvailableFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsAllowHumanGreyPercentageFlag] [bit] NOT NULL,
	[IsAllowSyntheticGreyPercentageFlag] [bit] NOT NULL,
	[IsAvailableForSignatureHairlineFlag] [bit] NOT NULL,
	[IsAvailableForOmbreFlag] [bit] NOT NULL,
	[IsLongHairAddOnFlag] [bit] NOT NULL,
	[IsCuticleIntactAvailableFlag] [bit] NOT NULL,
	[IsRootShadowingAvailableFlag] [bit] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemHairLength] PRIMARY KEY CLUSTERED
(
	[HairSystemHairLengthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
