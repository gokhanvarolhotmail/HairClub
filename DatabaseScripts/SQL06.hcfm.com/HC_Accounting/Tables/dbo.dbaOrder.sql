/* CreateDate: 10/03/2019 22:32:12.107 , ModifyDate: 03/25/2021 09:59:00.610 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dbaOrder](
	[OrderID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SalesOrderInvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesOrderType] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesOrderlineID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ReferenceSalesOrderInvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TransactionCenterID] [int] NOT NULL,
	[TransactionCenterName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientHomeCenterID] [int] NOT NULL,
	[ClientHomeCenterName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[OrderDateOnlyCalc]  AS (dateadd(day,(0),datediff(day,(0),[OrderDate]))),
	[IsOrderInBalance] [bit] NOT NULL,
	[IsOrderVoided] [bit] NOT NULL,
	[IsOrderClosed] [bit] NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[LastName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[FirstName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipID] [int] NOT NULL,
	[MembershipDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[BusinessSegment] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientMembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GL] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GLName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Division] [int] NULL,
	[DivisionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Department] [int] NULL,
	[DepartmentDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Code] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesCodeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeId] [int] NULL,
	[UnitPrice] [money] NULL,
	[Quantity] [int] NULL,
	[QuantityPrice] [money] NULL,
	[Discount] [money] NULL,
	[NetPrice] [money] NULL,
	[Price] [money] NULL,
	[Tender] [money] NULL,
	[DepositNumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RecordLastUpdate] [datetime] NOT NULL,
	[SalesOrderLastUpdate] [datetime] NOT NULL,
	[SalesOrderGuid] [uniqueidentifier] NOT NULL,
	[ReferenceSalesOrderGuid] [uniqueidentifier] NULL,
	[SalesOrderDetailGuid] [uniqueidentifier] NULL,
	[SalesOrderTenderGuid] [uniqueidentifier] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleyProcedureOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleyConsultOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreditCardLast4Digits] [nvarchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeSerialNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemOrderNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Tax1] [money] NULL,
	[Tax2] [money] NULL,
	[TotalTax]  AS (isnull([Tax1],(0.00))+isnull([Tax2],(0.00))),
	[ApprovalCode] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_dbaOrder] ON [dbo].[dbaOrder]
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_dbaOrder_Code] ON [dbo].[dbaOrder]
(
	[Code] ASC
)
INCLUDE([OrderID],[SalesOrderInvoiceNumber],[SalesOrderType],[SalesOrderlineID],[ReferenceSalesOrderInvoiceNumber],[TransactionCenterID],[TransactionCenterName],[ClientHomeCenterID],[ClientHomeCenterName],[OrderDate],[OrderDateOnlyCalc],[IsOrderInBalance],[IsOrderVoided],[IsOrderClosed],[ClientIdentifier],[LastName],[FirstName],[MembershipID],[MembershipDescription],[BusinessSegment],[ClientMembershipIdentifier],[GL],[GLName],[Division],[DivisionDescription],[Department],[DepartmentDescription],[SalesCodeDescription],[SalesCodeId],[UnitPrice],[Quantity],[QuantityPrice],[Discount],[NetPrice],[Tax1],[Tax2],[Price],[Tender],[DepositNumber],[RecordLastUpdate],[SalesOrderLastUpdate],[SalesOrderGuid],[ReferenceSalesOrderGuid],[SalesOrderDetailGuid],[SalesOrderTenderGuid],[CreateDate],[CreateUser],[LastUpdate],[LastUpdateUser],[SiebelID],[BosleyProcedureOffice],[BosleyConsultOffice],[CreditCardLast4Digits],[SalesCodeSerialNumber]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbaOrder_OrderDateGL_INCL] ON [dbo].[dbaOrder]
(
	[OrderDate] ASC
)
INCLUDE([GL],[GLName],[Quantity],[NetPrice],[Price],[TotalTax]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE NONCLUSTERED INDEX [IX_dbaOrder_OrderDateOnlyCalc] ON [dbo].[dbaOrder]
(
	[OrderDateOnlyCalc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbaOrder_RecordLastUpdate] ON [dbo].[dbaOrder]
(
	[RecordLastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbaOrder_RecordLastUpdate_SalesOrderLastUpdate] ON [dbo].[dbaOrder]
(
	[RecordLastUpdate] DESC,
	[SalesOrderLastUpdate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbaOrder_SalesOrderDetailGuid] ON [dbo].[dbaOrder]
(
	[SalesOrderDetailGuid] ASC
)
INCLUDE([OrderID],[RecordLastUpdate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_dbaOrder_SalesOrderTenderGUID] ON [dbo].[dbaOrder]
(
	[SalesOrderTenderGuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SalesOrderGuid_OrderId_SalesOrderDetailGuid_SalesOrderLastUpdate_RecordLastUpdate] ON [dbo].[dbaOrder]
(
	[SalesOrderGuid] ASC,
	[OrderID] ASC,
	[SalesOrderDetailGuid] ASC,
	[SalesOrderLastUpdate] ASC,
	[RecordLastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
