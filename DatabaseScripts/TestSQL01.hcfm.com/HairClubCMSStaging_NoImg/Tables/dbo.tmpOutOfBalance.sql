/* CreateDate: 07/16/2020 13:48:46.160 , ModifyDate: 07/16/2020 13:48:46.283 */
GO
CREATE TABLE [dbo].[tmpOutOfBalance](
	[CenterName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientName] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OrderType] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOrderGUID] [uniqueidentifier] NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodes] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DetailTotal] [decimal](18, 2) NULL,
	[Tenders] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TenderTotal] [decimal](18, 2) NULL,
	[Employee] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IssueResolved] [datetime] NULL,
	[IssueResolution] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_tmpOutOfBalance_SalesOrderGUID] ON [dbo].[tmpOutOfBalance]
(
	[SalesOrderGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
