/* CreateDate: 05/28/2018 21:15:00.790 , ModifyDate: 03/14/2019 06:34:17.470 */
GO
CREATE TABLE [dbo].[datSalesCodeDistributorSnapshot](
	[SalesCodeDistributorSnapshotID] [int] IDENTITY(1,1) NOT NULL,
	[ItemSKU] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuantityAvailable] [int] NULL,
	[Warehouse] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AreaName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SSISRunInstance] [datetime] NULL,
	[ItemSalesCodeID] [int] NULL,
	[PackSalesCodeID] [int] NULL,
 CONSTRAINT [PK_datSalesCodeDistributorSnapshot] PRIMARY KEY CLUSTERED
(
	[SalesCodeDistributorSnapshotID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datSalesCodeDistributorSnapshot_SSISRunInstance] ON [dbo].[datSalesCodeDistributorSnapshot]
(
	[SSISRunInstance] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
