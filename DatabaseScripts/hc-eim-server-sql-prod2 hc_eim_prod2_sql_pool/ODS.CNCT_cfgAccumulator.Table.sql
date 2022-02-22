/****** Object:  Table [ODS].[CNCT_cfgAccumulator]    Script Date: 2/22/2022 9:20:33 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_cfgAccumulator]
(
	[AccumulatorID] [int] NULL,
	[AccumulatorSortOrder] [int] NULL,
	[AccumulatorDescription] [nvarchar](50) NULL,
	[AccumulatorDescriptionShort] [nvarchar](10) NULL,
	[AccumulatorDataTypeID] [int] NULL,
	[SalesOrderProcessFlag] [bit] NULL,
	[SchedulerProcessFlag] [bit] NULL,
	[SchedulerActionTypeID] [int] NULL,
	[SchedulerAdjustmentTypeID] [int] NULL,
	[AdjustARBalanceFlag] [bit] NULL,
	[AdjustContractPriceFlag] [bit] NULL,
	[AdjustContractPaidFlag] [bit] NULL,
	[IsVisibleFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[IsVisibleToClient] [bit] NULL,
	[ClientDescription] [nvarchar](50) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
