/* CreateDate: 05/05/2020 17:42:48.020 , ModifyDate: 05/05/2020 18:28:45.553 */
GO
CREATE TABLE [dbo].[datClientMembershipAddOn](
	[ClientMembershipAddOnID] [int] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[AddOnID] [int] NOT NULL,
	[ClientMembershipAddOnStatusID] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[Quantity] [int] NOT NULL,
	[MonthlyFee] [money] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NULL,
	[Term] [int] NULL,
	[ContractPrice] [money] NOT NULL,
	[ContractPaidAmount] [money] NOT NULL,
	[ContractBalanceAmount]  AS ([ContractPrice]-[ContractPaidAmount])
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_datClientMembershipAddOnID] ON [dbo].[datClientMembershipAddOn]
(
	[ClientMembershipAddOnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembershipAddOn_ClientMembershipGUID] ON [dbo].[datClientMembershipAddOn]
(
	[ClientMembershipGUID] ASC
)
INCLUDE([ClientMembershipAddOnID],[AddOnID],[ClientMembershipAddOnStatusID],[MonthlyFee],[ContractPrice],[ContractPaidAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
