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
