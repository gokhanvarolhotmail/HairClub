/****** Object:  Table [ODS].[CNCT_lkpAccumulatorDataType]    Script Date: 3/12/2022 7:09:09 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpAccumulatorDataType]
(
	[AccumulatorDataTypeID] [int] NULL,
	[AccumulatorDataTypeSortOrder] [int] NULL,
	[AccumulatorDataTypeDescription] [nvarchar](100) NULL,
	[AccumulatorDataTypeDescriptionShort] [nvarchar](10) NULL,
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
