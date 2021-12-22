/* CreateDate: 11/01/2019 09:34:53.393 , ModifyDate: 11/01/2019 09:34:53.547 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
