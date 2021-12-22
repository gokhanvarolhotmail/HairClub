/* CreateDate: 03/16/2021 10:54:53.250 , ModifyDate: 03/16/2021 10:54:53.250 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
