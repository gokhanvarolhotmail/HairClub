/****** Object:  Table [ODS].[CNCT_lkpTimeZone]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpTimeZone]
(
	[TimeZoneID] [int] NULL,
	[TimeZoneSortOrder] [int] NULL,
	[TimeZoneDescription] [varchar](8000) NULL,
	[TimeZoneDescriptionShort] [varchar](8000) NULL,
	[UTCOffset] [int] NULL,
	[UsesDayLightSavingsFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
