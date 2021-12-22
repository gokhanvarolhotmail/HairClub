/* CreateDate: 05/29/2018 10:13:54.150 , ModifyDate: 05/29/2018 10:13:54.150 */
GO
CREATE TABLE [dbo].[tmpInventorySalesCodeDistributorBefore](
	[ItemSKU] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PackSKU] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuantityAvailable] [int] NULL,
	[SalesCodeID] [int] NULL,
	[SSISRunInstance] [datetime] NULL
) ON [PRIMARY]
GO
