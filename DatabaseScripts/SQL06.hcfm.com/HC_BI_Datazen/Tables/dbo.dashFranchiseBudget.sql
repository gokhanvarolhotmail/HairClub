/* CreateDate: 12/21/2016 09:20:39.147 , ModifyDate: 12/21/2016 09:20:39.147 */
GO
CREATE TABLE [dbo].[dashFranchiseBudget](
	[CenterSSID] [int] NOT NULL,
	[FirstDateOfMonth] [datetime] NOT NULL,
	[RetailAmt] [int] NULL,
	[ServiceAmt] [int] NULL,
	[XTRPlusConv] [int] NULL,
	[XTRConv] [int] NULL,
	[EXTConv] [int] NULL,
	[TotalCenterSales] [int] NULL,
	[NB2Sales] [int] NULL,
	[Trad] [int] NULL,
	[Grad] [int] NULL,
	[EXT] [int] NULL,
	[PostEXT] [int] NULL,
	[Surgery] [int] NULL,
	[Xtrands] [int] NULL,
	[TotalNBCount] [int] NULL,
	[NB_TradAmt] [int] NULL,
	[NB_GradAmt] [int] NULL,
	[NB_ExtAmt] [int] NULL,
	[S_PostExtAmt] [int] NULL,
	[S_SurAmt] [int] NULL,
	[NB_XTRAmt] [int] NULL,
	[TotalNBRevenue] [int] NULL,
	[NetNB1Sales] [int] NULL
) ON [PRIMARY]
GO
