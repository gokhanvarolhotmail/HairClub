/****** Object:  Table [ODS].[NBSalesAugustValidationm]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[NBSalesAugustValidationm]
(
	[CenterNumber] [varchar](8000) NULL,
	[NB1Applications] [varchar](8000) NULL,
	[GrossNB1Count] [varchar](8000) NULL,
	[NetNB1Count] [varchar](8000) NULL,
	[NetNB1Sales] [varchar](8000) NULL,
	[NetTradCount] [varchar](8000) NULL,
	[NetTradSales] [varchar](8000) NULL,
	[NetEXTCount] [varchar](8000) NULL,
	[NetEXTSales] [varchar](8000) NULL,
	[NetXtrCount] [varchar](8000) NULL,
	[NetXtrSales] [varchar](8000) NULL,
	[NetGradCount] [varchar](8000) NULL,
	[NetGradSales] [varchar](8000) NULL,
	[SurgeryCount] [varchar](8000) NULL,
	[SurgerySales] [varchar](8000) NULL,
	[PostEXTCount] [varchar](8000) NULL,
	[PostEXTSales] [varchar](8000) NULL,
	[ClientARBalance] [varchar](8000) NULL,
	[NB_MDPCnt] [varchar](8000) NULL,
	[NB_MDPAmt] [varchar](8000) NULL,
	[LaserCnt] [varchar](8000) NULL,
	[LaserAmt] [varchar](8000) NULL,
	[S_PRPCnt] [varchar](8000) NULL,
	[S_PRPAmt] [varchar](8000) NULL,
	[SalesCodeSSID] [varchar](8000) NULL,
	[CenterTypeDescriptionShort] [varchar](8000) NULL,
	[SalesOrderSSID] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
