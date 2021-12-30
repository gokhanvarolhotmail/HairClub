/* CreateDate: 03/11/2021 16:45:36.717 , ModifyDate: 03/16/2021 10:04:05.680 */
GO
CREATE TABLE [dbo].[HairColor](
	[HairSystemHairColorID] [float] NULL,
	[HairSystemHairColorSortOrder] [float] NULL,
	[HairSystemHairColorDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemHairColorDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairColorGroupCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairColorGroupDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemHairColorGroupID] [float] NULL
) ON [PRIMARY]
GO
