/* CreateDate: 03/16/2021 10:54:53.370 , ModifyDate: 03/16/2021 10:54:53.370 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HairLength](
	[HairSystemHairLengthID] [float] NULL,
	[HairLengthDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLengthDescriptionShort] [float] NULL,
	[HairLengthValue] [float] NULL,
	[LengthGroupCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LengthGroupDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
