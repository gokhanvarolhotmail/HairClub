/* CreateDate: 11/20/2019 14:39:58.280 , ModifyDate: 11/20/2019 14:39:58.280 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dba].[AllocationSummary5_PostAPAdjust2](
	[VendorID] [int] NULL,
	[HairSystemHairLengthID] [int] NULL,
	[HairSystemHairLengthDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemHairCapID] [int] NULL,
	[HairSystemHairCapDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Order Count] [int] NULL,
	[Total CostContract] [money] NULL,
	[Total CostActual] [money] NULL
) ON [PRIMARY]
GO
