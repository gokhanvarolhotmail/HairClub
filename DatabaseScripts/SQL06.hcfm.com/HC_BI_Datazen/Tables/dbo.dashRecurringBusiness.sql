/* CreateDate: 05/29/2019 14:47:00.270 , ModifyDate: 05/29/2019 14:47:00.270 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dashRecurringBusiness](
	[FirstDateOfMonth] [datetime] NOT NULL,
	[YearNumber] [int] NOT NULL,
	[YearMonthNumber] [int] NOT NULL,
	[CenterNumber] [int] NOT NULL,
	[CenterDescription] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NBApps] [int] NULL,
	[BIOPCPCount_Budget] [int] NULL,
	[XtrandsPCPCount_Budget] [int] NULL,
	[EXTPCPCount_Budget] [int] NULL,
	[BIOPCPCount] [int] NULL,
	[XtrandsPCPCount] [int] NULL,
	[EXTPCPCount] [int] NULL,
	[BIOConvCnt_Budget] [int] NULL,
	[XtrandsConvCnt_Budget] [int] NULL,
	[EXTConvCnt_Budget] [int] NULL,
	[BIOConvCnt_Actual] [int] NULL,
	[XtrandsConvCnt_Actual] [int] NULL,
	[EXTConvCnt_Actual] [int] NULL,
	[BIOPCPAmt_Budget] [int] NULL,
	[XtrandsPCPAmt_Budget] [int] NULL,
	[EXTMEMPCPAmt_Budget] [int] NULL,
	[TotalPCPAmt_Budget] [int] NULL,
	[RetailAmt_Budget] [int] NULL,
	[ServiceAmt_Budget] [int] NULL,
	[TotalRevenue_Budget] [int] NULL,
	[BIOPCPAmt_Actual] [int] NULL,
	[XtrandsPCPAmt_Actual] [int] NULL,
	[EXTMEMPCPAmt_Actual] [int] NULL,
	[TotalPCPAmt_Actual] [int] NULL,
	[TotalCenterSales] [int] NULL,
	[RetailAmt] [int] NULL,
	[ServiceAmt] [int] NULL,
	[NB_XTRCnt] [int] NULL,
	[NB_ExtCnt] [int] NULL
) ON [PRIMARY]
GO
