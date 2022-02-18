/* CreateDate: 10/04/2010 12:08:46.023 , ModifyDate: 01/31/2022 08:32:31.740 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemHairLength] ADD  DEFAULT ((0)) FOR [IsHumanHairAvailableFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemHairLength] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemHairLength] ADD  DEFAULT ((0)) FOR [IsAllowHumanGreyPercentageFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemHairLength] ADD  DEFAULT ((1)) FOR [IsAllowSyntheticGreyPercentageFlag]
GO
