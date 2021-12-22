/* CreateDate: 04/24/2017 08:10:29.357 , ModifyDate: 12/03/2021 10:24:48.737 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgCenterMembershipAddOn](
	[CenterMembershipAddOnID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterMembershipID] [int] NOT NULL,
	[AddOnID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NULL,
	[PriceDefault] [money] NULL,
	[PriceMinimum] [money] NULL,
	[PriceMaximum] [money] NULL,
	[QuantityMinimum] [int] NULL,
	[QuantityMaximum] [int] NULL,
	[PaymentSalesCodeID] [int] NULL,
	[MonthlyFeeSalesCodeID] [int] NULL,
	[AgreementID] [int] NULL,
	[QuantityIntervalMultiplier] [int] NULL,
	[ValuationPrice] [money] NULL,
 CONSTRAINT [PK_cfgCenterMembershipAddOnID] PRIMARY KEY CLUSTERED
(
	[CenterMembershipAddOnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgCenerMembershipAddOn_CenterMembershipID_AddOnID] ON [dbo].[cfgCenterMembershipAddOn]
(
	[CenterMembershipID] ASC,
	[AddOnID] ASC
)
INCLUDE([MonthlyFeeSalesCodeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgAddOn] FOREIGN KEY([AddOnID])
REFERENCES [dbo].[cfgAddOn] ([AddOnID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn] CHECK CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgAddOn]
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgAgreement] FOREIGN KEY([AgreementID])
REFERENCES [dbo].[cfgAgreement] ([AgreementID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn] CHECK CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgAgreement]
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgCenterMembership] FOREIGN KEY([CenterMembershipID])
REFERENCES [dbo].[cfgCenterMembership] ([CenterMembershipID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn] CHECK CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgCenterMembership]
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgSalesCode] FOREIGN KEY([PaymentSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn] CHECK CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgSalesCode]
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgSalesCode1] FOREIGN KEY([MonthlyFeeSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgCenterMembershipAddOn] CHECK CONSTRAINT [FK_cfgCenterMembershipAddOn_cfgSalesCode1]
GO
