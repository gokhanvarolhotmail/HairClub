/****** Object:  Table [dbo].[T_2103_6875adb2bf304bca9a6f24c2090254e5]    Script Date: 2/7/2022 10:45:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2103_6875adb2bf304bca9a6f24c2090254e5]
(
	[SalesCodeDepartmentID] [int] NULL,
	[SalesCodeDepartmentName] [nvarchar](max) NULL,
	[SalesCodeDepartmentNameShort] [nvarchar](max) NULL,
	[SalesCodeDivisionID] [int] NULL,
	[SalesCodeDivisionName] [nvarchar](max) NULL,
	[SalesCodeDivisionNameShort] [nvarchar](max) NULL,
	[SalesCodeDepartmentCreateDate] [datetime2](7) NULL,
	[SalesCodeDepartmentLastUpdateDate] [datetime2](7) NULL,
	[DWH_LoadDate] [datetime2](7) NULL,
	[DWH_LastUpdateDate] [datetime2](7) NULL,
	[IsActive] [bit] NULL,
	[SourceSystem] [nvarchar](max) NULL,
	[ra29f904e2b5d4286bb38577aa2f7385e] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
