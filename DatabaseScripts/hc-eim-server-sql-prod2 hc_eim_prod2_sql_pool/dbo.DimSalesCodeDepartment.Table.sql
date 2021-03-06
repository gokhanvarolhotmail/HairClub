/****** Object:  Table [dbo].[DimSalesCodeDepartment]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalesCodeDepartment]
(
	[SalesCodeDepartmentKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesCodeDepartmentID] [int] NULL,
	[SalesCodeDepartmentName] [nvarchar](100) NOT NULL,
	[SalesCodeDepartmentNameShort] [nvarchar](50) NOT NULL,
	[SalesCodeDivisionID] [int] NULL,
	[SalesCodeDivisionName] [nvarchar](100) NULL,
	[SalesCodeDivisionNameShort] [nvarchar](50) NULL,
	[SalesCodeDepartmentCreateDate] [datetime] NULL,
	[SalesCodeDepartmentLastUpdateDate] [datetime] NULL,
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
		[SalesCodeDepartmentKey] ASC
	)
)
GO
