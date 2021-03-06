/****** Object:  Table [dbo].[DimSalesCode]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalesCode]
(
	[SalesCodeKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesCodeID] [int] NULL,
	[SalesCodeName] [nvarchar](100) NULL,
	[SalesCodeNameShort] [nvarchar](100) NULL,
	[SalesCodeDepartmentKey] [int] NULL,
	[SalesCodeDepartmentID] [int] NULL,
	[SalesCodeTypeID] [int] NULL,
	[SalesCodeTypeName] [nvarchar](100) NULL,
	[SalesCodeTypeNameShort] [nvarchar](100) NULL,
	[SalesCodeCreateDate] [datetime] NULL,
	[SalesCodeLastUpdateDate] [datetime] NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[SalesCodeKey] ASC
	)
)
GO
