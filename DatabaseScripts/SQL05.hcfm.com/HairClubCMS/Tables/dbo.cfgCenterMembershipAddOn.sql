/* CreateDate: 05/05/2020 17:42:40.470 , ModifyDate: 05/05/2020 18:28:04.787 */
GO
CREATE TABLE [dbo].[cfgCenterMembershipAddOn](
	[CenterMembershipAddOnID] [int] NOT NULL,
	[CenterMembershipID] [int] NOT NULL,
	[AddOnID] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [binary](8) NULL,
	[PriceDefault] [money] NULL,
	[PriceMinimum] [money] NULL,
	[PriceMaximum] [money] NULL,
	[QuantityMinimum] [int] NULL,
	[QuantityMaximum] [int] NULL,
	[PaymentSalesCodeID] [int] NULL,
	[MonthlyFeeSalesCodeID] [int] NULL,
	[AgreementID] [int] NULL,
	[QuantityIntervalMultiplier] [int] NULL,
	[ValuationPrice] [money] NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_cfgCenterMembershipAddOnID] ON [dbo].[cfgCenterMembershipAddOn]
(
	[CenterMembershipAddOnID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_cfgCenerMembershipAddOn_CenterMembershipID_AddOnID] ON [dbo].[cfgCenterMembershipAddOn]
(
	[CenterMembershipID] ASC,
	[AddOnID] ASC
)
INCLUDE([MonthlyFeeSalesCodeID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
