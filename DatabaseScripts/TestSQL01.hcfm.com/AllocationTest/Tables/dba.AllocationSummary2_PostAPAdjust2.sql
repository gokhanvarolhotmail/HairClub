/* CreateDate: 11/20/2019 14:38:42.153 , ModifyDate: 11/20/2019 14:38:42.153 */
GO
CREATE TABLE [dba].[AllocationSummary2_PostAPAdjust2](
	[HairSystemAllocationGUID] [uniqueidentifier] NOT NULL,
	[HairSystemAllocationDate] [datetime] NULL,
	[VendorID] [int] NULL,
	[HairSystemHairLengthID] [int] NULL,
	[HairSystemHairLengthDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemHairCapID] [int] NULL,
	[HairSystemHairCapDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
