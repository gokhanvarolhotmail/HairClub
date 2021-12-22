CREATE TABLE [dbo].[Center_LatLong](
	[CenterSSID] [float] NULL,
	[CenterDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterAddress1] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateProvinceDescriptionShort] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [float] NULL,
	[Address] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lat] [float] NULL,
	[long] [float] NULL
) ON [PRIMARY]
