/* CreateDate: 12/07/2020 16:29:29.917 , ModifyDate: 12/07/2020 16:29:29.917 */
GO
CREATE TABLE [dbo].[NonserializedInventorySnapshot](
	[Snapshot Date] [date] NOT NULL,
	[CenterID] [int] NOT NULL,
	[Center Name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Area] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Center Audit Status] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Item SKU] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Item Description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Current Quantity] [int] NOT NULL,
	[Snapshot Quantity] [int] NOT NULL,
	[Entered Quantity] [int] NOT NULL,
	[Variance] [int] NOT NULL,
	[Per Item Cost] [money] NULL,
	[Variance Cost] [int] NULL
) ON [PRIMARY]
GO
