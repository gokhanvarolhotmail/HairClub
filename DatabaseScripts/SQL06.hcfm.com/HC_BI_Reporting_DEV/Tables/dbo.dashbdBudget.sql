/* CreateDate: 07/14/2014 14:54:42.400 , ModifyDate: 07/14/2014 14:54:42.400 */
GO
CREATE TABLE [dbo].[dashbdBudget](
	[CenterID] [int] NULL,
	[CenterDescriptionNumber] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DateKey] [int] NULL,
	[PartitionDate] [datetime] NULL,
	[AccountID] [int] NULL,
	[Budget] [decimal](13, 2) NULL,
	[Actual] [decimal](13, 2) NULL,
	[AccountDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Type] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RegionKey] [int] NULL,
	[RegionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
