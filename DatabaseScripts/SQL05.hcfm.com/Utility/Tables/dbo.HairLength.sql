/* CreateDate: 03/11/2021 16:45:36.863 , ModifyDate: 03/16/2021 10:06:13.473 */
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
