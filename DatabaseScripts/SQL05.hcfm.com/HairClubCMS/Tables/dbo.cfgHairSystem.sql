/* CreateDate: 05/05/2020 17:42:37.580 , ModifyDate: 05/05/2020 18:41:06.360 */
GO
CREATE TABLE [dbo].[cfgHairSystem](
	[HairSystemID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemSortOrder] [int] NOT NULL,
	[HairSystemDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemTypeID] [int] NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[UseHairSystemFrontalLaceLengthFlag] [bit] NOT NULL,
	[AllowFashionHairlineHighlightsFlag] [bit] NOT NULL,
	[HairSystemGroupID] [int] NOT NULL,
	[AllowSignatureHairlineFlag] [bit] NOT NULL,
	[AllowCuticleIntactHairFlag] [bit] NOT NULL,
 CONSTRAINT [PK_cfgHairSystem] PRIMARY KEY CLUSTERED
(
	[HairSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
