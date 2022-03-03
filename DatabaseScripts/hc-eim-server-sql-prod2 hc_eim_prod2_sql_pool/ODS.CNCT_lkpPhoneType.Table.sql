/****** Object:  Table [ODS].[CNCT_lkpPhoneType]    Script Date: 3/3/2022 9:01:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpPhoneType]
(
	[PhoneTypeID] [int] NULL,
	[PhoneTypeSortOrder] [int] NULL,
	[PhoneTypeDescription] [nvarchar](max) NULL,
	[PhoneTypeDescriptionShort] [nvarchar](max) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[CanTextMessageFlag] [bit] NULL,
	[PhoneSegmentId] [int] NULL,
	[DescriptionResourceKey] [nvarchar](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
