/* CreateDate: 04/24/2017 08:10:29.280 , ModifyDate: 02/04/2022 21:30:29.267 */
GO
CREATE TABLE [dbo].[datClientMembershipAddOn](
	[ClientMembershipAddOnID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
	[UpdateStamp] [timestamp] NULL,
	[Term] [int] NULL,
	[ContractPrice] [money] NOT NULL,
	[ContractPaidAmount] [money] NOT NULL,
	[ContractBalanceAmount]  AS ([ContractPrice]-[ContractPaidAmount]),
 CONSTRAINT [PK_datClientMembershipAddOnID] PRIMARY KEY CLUSTERED
(
	[ClientMembershipAddOnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembershipAddOn_ClientMembershipGUID] ON [dbo].[datClientMembershipAddOn]
(
	[ClientMembershipGUID] ASC
)
INCLUDE([ClientMembershipAddOnID],[AddOnID],[ClientMembershipAddOnStatusID],[MonthlyFee],[ContractPrice],[ContractPaidAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientMembershipAddOn]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipAddOn_cfgAddOn] FOREIGN KEY([AddOnID])
REFERENCES [dbo].[cfgAddOn] ([AddOnID])
GO
ALTER TABLE [dbo].[datClientMembershipAddOn] CHECK CONSTRAINT [FK_datClientMembershipAddOn_cfgAddOn]
GO
ALTER TABLE [dbo].[datClientMembershipAddOn]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipAddOn_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datClientMembershipAddOn] CHECK CONSTRAINT [FK_datClientMembershipAddOn_datClientMembership]
GO
ALTER TABLE [dbo].[datClientMembershipAddOn]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipAddOn_lkpClientMembershipAddOnStatus] FOREIGN KEY([ClientMembershipAddOnStatusID])
REFERENCES [dbo].[lkpClientMembershipAddOnStatus] ([ClientMembershipAddOnStatusID])
GO
ALTER TABLE [dbo].[datClientMembershipAddOn] CHECK CONSTRAINT [FK_datClientMembershipAddOn_lkpClientMembershipAddOnStatus]
GO
