/****** Object:  Table [ODS].[T_2101_43a1d77cf40b48d4a5fb7315960dc12a]    Script Date: 2/10/2022 9:07:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[T_2101_43a1d77cf40b48d4a5fb7315960dc12a]
(
	[TimeZoneID] [int] NULL,
	[TimeZoneSortOrder] [int] NULL,
	[TimeZoneDescription] [nvarchar](max) NULL,
	[TimeZoneDescriptionShort] [nvarchar](max) NULL,
	[UTCOffset] [int] NULL,
	[UsesDayLightSavingsFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[r6dd26bc0744f4d30b4286793b23aa246] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
