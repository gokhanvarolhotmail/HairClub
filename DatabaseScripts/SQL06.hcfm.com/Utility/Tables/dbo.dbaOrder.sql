/* CreateDate: 12/15/2016 14:32:53.813 , ModifyDate: 12/15/2016 14:32:53.883 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dbaOrder](
	[OrderID] [int] NOT NULL,
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
	[TotalTax]  AS (isnull([Tax1],(0.00))+isnull([Tax2],(0.00)))
) ON [PRIMARY]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_dbaOrder] ON [dbo].[dbaOrder]
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
