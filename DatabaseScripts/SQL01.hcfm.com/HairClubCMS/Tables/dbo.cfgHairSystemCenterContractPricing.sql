CREATE TABLE [dbo].[cfgHairSystemCenterContractPricing](
	[HairSystemCenterContractPricingID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemCenterContractID] [int] NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[HairSystemHairLengthID] [int] NOT NULL,
	[HairSystemPrice] [money] NOT NULL,
	[IsContractPriceInActive] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[HairSystemAreaRangeBegin] [int] NOT NULL,
	[HairSystemAreaRangeEnd] [int] NOT NULL,
	[AddOnSignatureHairlinePrice] [money] NOT NULL,
	[AddOnExtendedLacePrice] [money] NOT NULL,
	[AddOnOmbrePrice] [money] NOT NULL,
	[AddOnCuticleIntactHairPrice] [money] NOT NULL,
	[AddOnRootShadowingPrice] [money] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemCenterContractPricing] PRIMARY KEY CLUSTERED
(
	[HairSystemCenterContractPricingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemCenterContractPricing] ON [dbo].[cfgHairSystemCenterContractPricing]
(
	[HairSystemCenterContractID] ASC,
	[HairSystemID] ASC,
	[HairSystemHairLengthID] ASC,
	[HairSystemAreaRangeBegin] ASC,
	[HairSystemAreaRangeEnd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing] ADD  DEFAULT ((0)) FOR [HairSystemPrice]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing] ADD  DEFAULT ((0)) FOR [IsContractPriceInActive]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing] ADD  DEFAULT ((0)) FOR [HairSystemAreaRangeBegin]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing] ADD  DEFAULT ((0)) FOR [HairSystemAreaRangeEnd]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing]  WITH CHECK ADD  CONSTRAINT [cfgHairSystemCenterContractPricing_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing] CHECK CONSTRAINT [cfgHairSystemCenterContractPricing_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing]  WITH CHECK ADD  CONSTRAINT [cfgHairSystemCenterContractPricing_lkpHairSystemHairLength] FOREIGN KEY([HairSystemHairLengthID])
REFERENCES [dbo].[lkpHairSystemHairLength] ([HairSystemHairLengthID])
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing] CHECK CONSTRAINT [cfgHairSystemCenterContractPricing_lkpHairSystemHairLength]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemCenterContractPricing_cfgHairSystemCenterContract] FOREIGN KEY([HairSystemCenterContractID])
REFERENCES [dbo].[cfgHairSystemCenterContract] ([HairSystemCenterContractID])
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContractPricing] CHECK CONSTRAINT [FK_cfgHairSystemCenterContractPricing_cfgHairSystemCenterContract]
