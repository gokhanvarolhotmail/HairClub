/* CreateDate: 03/11/2021 16:45:36.800 , ModifyDate: 03/16/2021 10:05:14.020 */
GO
CREATE TABLE [dbo].[HairCurl](
	[HairSystemCurlID] [float] NULL,
	[HairSystemCurlSortOrder] [float] NULL,
	[HairSystemCurlDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemCurlDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurlGroupCode] [float] NULL,
	[HumanHairLengthMinimum] [float] NULL,
	[HumanHairLengthMaximum] [float] NULL,
	[SyntheticHairLengthMinimum] [float] NULL,
	[SyntheticHairLengthMaximum] [float] NULL,
	[CurlGroupDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
