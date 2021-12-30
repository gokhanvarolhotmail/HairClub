/* CreateDate: 10/04/2010 12:08:46.067 , ModifyDate: 12/28/2021 09:20:54.493 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemCurl] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemCurl] ADD  DEFAULT ((0)) FOR [IsAllowHumanGreyPercentageFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemCurl] ADD  DEFAULT ((1)) FOR [IsAllowSyntheticGreyPercentageFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemCurl]  WITH CHECK ADD  CONSTRAINT [FK_lkpHairSystemCurl_lkpHairSystemCurlGroup] FOREIGN KEY([HairSystemCurlGroupID])
REFERENCES [dbo].[lkpHairSystemCurlGroup] ([HairSystemCurlGroupID])
GO
ALTER TABLE [dbo].[lkpHairSystemCurl] CHECK CONSTRAINT [FK_lkpHairSystemCurl_lkpHairSystemCurlGroup]
GO
