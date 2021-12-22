/* CreateDate: 01/15/2020 14:38:25.923 , ModifyDate: 01/15/2020 14:38:25.923 */
GO
CREATE TABLE [alloc].[AllocationSummary5](
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
