/* CreateDate: 02/02/2009 08:51:08.987 , ModifyDate: 06/02/2021 04:00:56.160 */
GO
CREATE TABLE [dbo].[cfgSalesCodeMembership](
	[SalesCodeMembershipID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SalesCodeCenterID] [int] NULL,
	[MembershipID] [int] NULL,
	[Price] [money] NULL,
	[TaxRate1ID] [int] NULL,
	[TaxRate2ID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsFinancedToARFlag] [bit] NOT NULL,
 CONSTRAINT [PK_cfgSalesCodeMembership] PRIMARY KEY CLUSTERED
(
	[SalesCodeMembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeMembership_MembershipID_IsActiveFlag] ON [dbo].[cfgSalesCodeMembership]
(
	[MembershipID] ASC,
	[IsActiveFlag] ASC
)
INCLUDE([SalesCodeMembershipID],[SalesCodeCenterID],[Price],[TaxRate1ID],[TaxRate2ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeMembership_MembershipIDINCL] ON [dbo].[cfgSalesCodeMembership]
(
	[MembershipID] ASC
)
INCLUDE([Price],[SalesCodeCenterID],[TaxRate1ID],[TaxRate2ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeMembership_SalesCodeCenterID] ON [dbo].[cfgSalesCodeMembership]
(
	[SalesCodeCenterID] ASC
)
INCLUDE([SalesCodeMembershipID],[MembershipID],[TaxRate1ID],[TaxRate2ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership] ADD  CONSTRAINT [DF_cfgSalesCodeMembership_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership] ADD  DEFAULT ((0)) FOR [IsFinancedToARFlag]
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeMembership_cfgCenterTaxRate] FOREIGN KEY([TaxRate1ID])
REFERENCES [dbo].[cfgCenterTaxRate] ([CenterTaxRateID])
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership] CHECK CONSTRAINT [FK_cfgSalesCodeMembership_cfgCenterTaxRate]
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeMembership_cfgCenterTaxRate1] FOREIGN KEY([TaxRate2ID])
REFERENCES [dbo].[cfgCenterTaxRate] ([CenterTaxRateID])
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership] CHECK CONSTRAINT [FK_cfgSalesCodeMembership_cfgCenterTaxRate1]
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeMembership_cfgMembership] FOREIGN KEY([MembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership] CHECK CONSTRAINT [FK_cfgSalesCodeMembership_cfgMembership]
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeMembership_cfgSalesCodeCenter] FOREIGN KEY([SalesCodeCenterID])
REFERENCES [dbo].[cfgSalesCodeCenter] ([SalesCodeCenterID])
GO
ALTER TABLE [dbo].[cfgSalesCodeMembership] CHECK CONSTRAINT [FK_cfgSalesCodeMembership_cfgSalesCodeCenter]
GO
