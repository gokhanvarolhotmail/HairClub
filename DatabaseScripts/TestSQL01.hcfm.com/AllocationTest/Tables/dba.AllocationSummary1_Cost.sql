/* CreateDate: 11/04/2019 11:54:21.710 , ModifyDate: 11/04/2019 11:54:21.710 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dba].[AllocationSummary1_Cost](
	[HairSystemAllocationGUID] [uniqueidentifier] NOT NULL,
	[HairSystemAllocationDate] [datetime] NULL,
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
