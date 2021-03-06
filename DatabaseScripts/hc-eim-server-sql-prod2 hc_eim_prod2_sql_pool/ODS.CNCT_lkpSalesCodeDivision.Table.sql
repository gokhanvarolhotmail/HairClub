/****** Object:  Table [ODS].[CNCT_lkpSalesCodeDivision]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpSalesCodeDivision]
(
	[SalesCodeDivisionID] [int] NULL,
	[SalesCodeDivisionSortOrder] [int] NULL,
	[SalesCodeDivisionDescription] [nvarchar](100) NULL,
	[SalesCodeDivisionDescriptionShort] [nvarchar](10) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) NULL,
	[UpdateStamp] [varbinary](8) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
