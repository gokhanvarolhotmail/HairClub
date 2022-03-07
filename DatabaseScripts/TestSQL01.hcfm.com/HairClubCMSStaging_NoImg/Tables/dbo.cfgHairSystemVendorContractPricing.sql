/* CreateDate: 10/04/2010 12:08:46.250 , ModifyDate: 03/06/2022 20:36:59.247 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContractPricing](
	[HairSystemVendorContractPricingID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
	[UpdateStamp] [timestamp] NULL,
	[IsContractPriceInActive] [bit] NOT NULL,
	[AddOnSignatureHairlineCost] [money] NOT NULL,
	[AddOnExtendedLaceCost] [money] NOT NULL,
	[AddOnOmbreCost] [money] NOT NULL,
	[AddOnCuticleIntactHairCost] [money] NOT NULL,
	[AddOnRootShadowCost] [money] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemVendorContractPricing] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorContractPricingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemVendorContractPricing_HairSystemAreaRangeBegin] ON [dbo].[cfgHairSystemVendorContractPricing]
(
	[HairSystemAreaRangeBegin] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemVendorContractPricing_HairSystemAreaRangeEnd] ON [dbo].[cfgHairSystemVendorContractPricing]
(
	[HairSystemAreaRangeEnd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractPricing] ADD  DEFAULT ((0)) FOR [IsContractPriceInActive]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractPricing]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContractPricing_cfgHairSystemVendorContract] FOREIGN KEY([HairSystemVendorContractID])
REFERENCES [dbo].[cfgHairSystemVendorContract] ([HairSystemVendorContractID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractPricing] CHECK CONSTRAINT [FK_cfgHairSystemVendorContractPricing_cfgHairSystemVendorContract]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractPricing]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContractPricing_lkpHairSystemHairCap] FOREIGN KEY([HairSystemHairCapID])
REFERENCES [dbo].[lkpHairSystemHairCap] ([HairSystemHairCapID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractPricing] CHECK CONSTRAINT [FK_cfgHairSystemVendorContractPricing_lkpHairSystemHairCap]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractPricing]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContractPricing_lkpHairSystemHairLength] FOREIGN KEY([HairSystemHairLengthID])
REFERENCES [dbo].[lkpHairSystemHairLength] ([HairSystemHairLengthID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractPricing] CHECK CONSTRAINT [FK_cfgHairSystemVendorContractPricing_lkpHairSystemHairLength]
GO
