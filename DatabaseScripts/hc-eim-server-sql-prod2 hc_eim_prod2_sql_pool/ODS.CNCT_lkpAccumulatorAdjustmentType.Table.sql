/****** Object:  Table [ODS].[CNCT_lkpAccumulatorAdjustmentType]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpAccumulatorAdjustmentType]
(
	[AccumulatorAdjustmentTypeID] [int] NULL,
	[AccumulatorAdjustmentTypeSortOrder] [int] NULL,
	[AccumulatorAdjustmentTypeDescription] [nvarchar](100) NULL,
	[AccumulatorAdjustmentTypeDescriptionShort] [nvarchar](10) NULL,
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
