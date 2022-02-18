/****** Object:  Table [ODS].[CNCT_lkpSalesCodeType]    Script Date: 2/18/2022 8:28:27 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpSalesCodeType]
(
	[SalesCodeTypeID] [int] NULL,
	[SalesCodeTypeSortOrder] [int] NULL,
	[SalesCodeTypeDescription] [nvarchar](100) NULL,
	[SalesCodeTypeDescriptionShort] [nvarchar](10) NULL,
	[IsInventory] [bit] NULL,
	[IsSerialized] [bit] NULL,
	[IsHairSystem] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
