/****** Object:  Table [ODS].[CNCT_lkpSalesCodeDepartment]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpSalesCodeDepartment]
(
	[SalesCodeDepartmentID] [int] NULL,
	[SalesCodeDepartmentSortOrder] [int] NULL,
	[SalesCodeDepartmentDescription] [varchar](8000) NULL,
	[SalesCodeDepartmentDescriptionShort] [varchar](8000) NULL,
	[SalesCodeDivisionID] [int] NULL,
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
