/****** Object:  Table [ODS].[CNCT_lkpAccumulatorActionType]    Script Date: 2/7/2022 10:45:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpAccumulatorActionType]
(
	[AccumulatorActionTypeID] [int] NULL,
	[AccumulatorActionTypeSortOrder] [int] NULL,
	[AccumulatorActionTypeDescription] [nvarchar](100) NULL,
	[AccumulatorActionTypeDescriptionShort] [nvarchar](10) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) NULL,
	[UpdateStamp] [varbinary](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
