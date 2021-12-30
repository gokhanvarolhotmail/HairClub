/* CreateDate: 05/05/2020 17:42:43.027 , ModifyDate: 05/05/2020 18:41:05.323 */
GO
CREATE TABLE [dbo].[lkpHairSystemFrontalDensity](
	[HairSystemFrontalDensityID] [int] NOT NULL,
	[HairSystemFrontalDensitySortOrder] [int] NOT NULL,
	[HairSystemFrontalDensityDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemFrontalDensityDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsAvailableForSignatureHairlineFlag] [bit] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemFrontalDensity] PRIMARY KEY CLUSTERED
(
	[HairSystemFrontalDensityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
