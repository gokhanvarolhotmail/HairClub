/****** Object:  Table [ODS].[CNCT_lkpSalesOrderType]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpSalesOrderType]
(
	[SalesOrderTypeID] [int] NULL,
	[SalesOrderTypeSortOrder] [int] NULL,
	[SalesOrderTypeDescription] [nvarchar](max) NULL,
	[SalesOrderTypeDescriptionShort] [nvarchar](max) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
