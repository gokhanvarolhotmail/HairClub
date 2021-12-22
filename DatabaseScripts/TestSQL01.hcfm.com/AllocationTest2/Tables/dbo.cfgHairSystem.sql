/* CreateDate: 10/31/2019 20:53:42.443 , ModifyDate: 11/01/2019 09:57:48.970 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystem](
	[HairSystemID] [int] IDENTITY(1,1) NOT NULL,
	[HairSystemSortOrder] [int] NOT NULL,
	[HairSystemDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemTypeID] [int] NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UseHairSystemFrontalLaceLengthFlag] [bit] NOT NULL,
	[AllowFashionHairlineHighlightsFlag] [bit] NOT NULL,
	[HairSystemGroupID] [int] NOT NULL,
	[AllowSignatureHairlineFlag] [bit] NOT NULL
) ON [PRIMARY]
GO
