/* CreateDate: 10/26/2012 11:21:49.413 , ModifyDate: 03/27/2019 17:47:47.320 */
GO
CREATE TABLE [dbo].[FactCommissionDetail](
	[CommissionDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[CommissionHeaderKey] [int] NOT NULL,
	[ClientMembershipKey] [int] NULL,
	[MembershipKey] [int] NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesOrderDetailKey] [int] NOT NULL,
	[SalesOrderDate] [datetime] NULL,
	[SalesCodeKey] [int] NOT NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExtendedPrice] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
	[IsRefund] [bit] NOT NULL,
	[RefundSalesOrderDetailKey] [int] NULL,
	[IsEarnedTransaction] [bit] NOT NULL,
	[IsCancel] [bit] NULL,
	[RetractCommission] [bit] NULL,
	[IsRetracted] [bit] NULL,
	[IsValidTransaction] [bit] NULL,
	[CommissionErrorID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMembershipAddOnID] [int] NULL,
 CONSTRAINT [PK_FactCommissionDetail] PRIMARY KEY CLUSTERED
(
	[CommissionDetailKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ix_FactCommissionDetail_CommissionHeaderKey_INCL] ON [dbo].[FactCommissionDetail]
(
	[CommissionHeaderKey] ASC
)
INCLUDE([CommissionDetailKey],[SalesOrderDetailKey],[SalesOrderDate],[SalesCodeKey],[SalesCodeDescriptionShort],[IsEarnedTransaction],[IsCancel],[CreateDate],[CreateUser],[ExtendedPrice],[Quantity],[IsRefund],[RefundSalesOrderDetailKey],[UpdateDate],[UpdateUser],[RetractCommission],[IsRetracted],[IsValidTransaction],[CommissionErrorID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactCommissionDetail_IsValidTransaction_INCL] ON [dbo].[FactCommissionDetail]
(
	[IsValidTransaction] ASC
)
INCLUDE([ClientMembershipKey],[SalesCodeDescriptionShort],[ExtendedPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
