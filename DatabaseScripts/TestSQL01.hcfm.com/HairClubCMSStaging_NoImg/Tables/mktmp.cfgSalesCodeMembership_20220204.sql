/* CreateDate: 02/04/2022 12:30:25.207 , ModifyDate: 02/07/2022 11:04:11.923 */
GO
CREATE TABLE [mktmp].[cfgSalesCodeMembership_20220204](
	[SalesCodeMembershipID] [int] IDENTITY(1,1) NOT NULL,
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
 CONSTRAINT [PK_cfgSalesCodeMembership_20220204] PRIMARY KEY CLUSTERED
(
	[SalesCodeMembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeMembership_MembershipID_IsActiveFlag] ON [mktmp].[cfgSalesCodeMembership_20220204]
(
	[MembershipID] ASC,
	[IsActiveFlag] ASC
)
INCLUDE([SalesCodeMembershipID],[SalesCodeCenterID],[Price],[TaxRate1ID],[TaxRate2ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeMembership_MembershipIDINCL] ON [mktmp].[cfgSalesCodeMembership_20220204]
(
	[MembershipID] ASC
)
INCLUDE([Price],[SalesCodeCenterID],[TaxRate1ID],[TaxRate2ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeMembership_SalesCodeCenterID] ON [mktmp].[cfgSalesCodeMembership_20220204]
(
	[SalesCodeCenterID] ASC
)
INCLUDE([SalesCodeMembershipID],[MembershipID],[TaxRate1ID],[TaxRate2ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204] ADD  CONSTRAINT [DF_cfgSalesCodeMembership_IsActiveFlag_20220204]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204] ADD  DEFAULT ((0)) FOR [IsFinancedToARFlag]
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeMembership_cfgCenterTaxRate_20220204] FOREIGN KEY([TaxRate1ID])
REFERENCES [dbo].[cfgCenterTaxRate] ([CenterTaxRateID])
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204] CHECK CONSTRAINT [FK_cfgSalesCodeMembership_cfgCenterTaxRate_20220204]
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeMembership_cfgCenterTaxRate1_20220204] FOREIGN KEY([TaxRate2ID])
REFERENCES [dbo].[cfgCenterTaxRate] ([CenterTaxRateID])
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204] CHECK CONSTRAINT [FK_cfgSalesCodeMembership_cfgCenterTaxRate1_20220204]
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeMembership_cfgMembership_20220204] FOREIGN KEY([MembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204] CHECK CONSTRAINT [FK_cfgSalesCodeMembership_cfgMembership_20220204]
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeMembership_cfgSalesCodeCenter_20220204] FOREIGN KEY([SalesCodeCenterID])
REFERENCES [dbo].[cfgSalesCodeCenter] ([SalesCodeCenterID])
GO
ALTER TABLE [mktmp].[cfgSalesCodeMembership_20220204] CHECK CONSTRAINT [FK_cfgSalesCodeMembership_cfgSalesCodeCenter_20220204]
GO
