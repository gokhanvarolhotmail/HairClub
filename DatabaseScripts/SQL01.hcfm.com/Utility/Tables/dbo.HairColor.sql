CREATE TABLE [dbo].[HairColor](
	[HairSystemHairColorID] [float] NULL,
	[HairSystemHairColorSortOrder] [float] NULL,
	[HairSystemHairColorDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemHairColorDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairColorGroupCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairColorGroupDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemHairColorGroupID] [float] NULL
) ON [PRIMARY]
