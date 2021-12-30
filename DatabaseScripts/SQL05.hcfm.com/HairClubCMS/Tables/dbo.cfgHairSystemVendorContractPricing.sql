/* CreateDate: 05/05/2020 17:42:45.633 , ModifyDate: 05/05/2020 18:28:04.830 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContractPricing](
	[HairSystemVendorContractPricingID] [int] NOT NULL,
	[HairSystemVendorContractID] [int] NOT NULL,
	[HairSystemHairLengthID] [int] NOT NULL,
	[HairSystemHairCapID] [int] NULL,
	[HairSystemAreaRangeBegin] [decimal](23, 8) NOT NULL,
	[HairSystemAreaRangeEnd] [decimal](23, 8) NOT NULL,
	[HairSystemCost] [money] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [binary](8) NULL,
	[IsContractPriceInActive] [bit] NOT NULL,
	[AddOnSignatureHairlineCost] [money] NOT NULL,
	[AddOnExtendedLaceCost] [money] NOT NULL,
	[AddOnOmbreCost] [money] NOT NULL,
	[AddOnCuticleIntactHairCost] [money] NOT NULL,
	[AddOnRootShadowCost] [money] NOT NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_cfgHairSystemVendorContractPricing] ON [dbo].[cfgHairSystemVendorContractPricing]
(
	[HairSystemVendorContractPricingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemVendorContractPricing_HairSystemAreaRangeBegin] ON [dbo].[cfgHairSystemVendorContractPricing]
(
	[HairSystemAreaRangeBegin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemVendorContractPricing_HairSystemAreaRangeEnd] ON [dbo].[cfgHairSystemVendorContractPricing]
(
	[HairSystemAreaRangeEnd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
