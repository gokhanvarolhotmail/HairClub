/* CreateDate: 11/20/2019 09:52:20.360 , ModifyDate: 11/20/2019 09:52:20.360 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dba].[AllocationSummary3_PostAPAdjust](
	[HairSystemAllocationGUID] [uniqueidentifier] NOT NULL,
	[HairSystemAllocationDate] [datetime] NULL,
	[VendorID] [int] NULL,
	[Order Count] [int] NULL,
	[Total CostContract] [money] NULL,
	[Total CostActual] [money] NULL,
	[Order Count Sum] [int] NULL,
	[CostContract Sum] [money] NULL,
	[CostActual Sum] [money] NULL,
	[Order Count Percent] [decimal](10, 4) NULL,
	[CostContract Percent] [money] NULL,
	[CostActual Percent] [money] NULL
) ON [PRIMARY]
GO
