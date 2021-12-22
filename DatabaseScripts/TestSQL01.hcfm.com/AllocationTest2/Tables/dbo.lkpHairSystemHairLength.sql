/* CreateDate: 11/04/2019 10:11:47.087 , ModifyDate: 11/04/2019 10:11:47.087 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
	[UpdateStamp] [timestamp] NOT NULL,
	[IsAllowHumanGreyPercentageFlag] [bit] NOT NULL,
	[IsAllowSyntheticGreyPercentageFlag] [bit] NOT NULL,
	[IsAvailableForSignatureHairlineFlag] [bit] NOT NULL,
	[IsAvailableForOmbreFlag] [bit] NOT NULL,
	[IsLongHairAddOnFlag] [bit] NOT NULL
) ON [PRIMARY]
GO
