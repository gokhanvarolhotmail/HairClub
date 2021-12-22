/* CreateDate: 06/08/2013 20:31:14.977 , ModifyDate: 06/08/2013 20:31:14.977 */
GO
CREATE TABLE [dbo].[FactDeferredRevenueTransactions_06082013](
	[DeferredRevenueHeaderKey] [int] NOT NULL,
	[DeferredRevenueTransactionsKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[SalesOrderDetailKey] [int] NOT NULL,
	[SalesOrderDate] [datetime] NOT NULL,
	[SalesCodeKey] [int] NOT NULL,
	[SalesCodeDescriptionShort] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ExtendedPrice] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
