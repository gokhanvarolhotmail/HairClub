/* CreateDate: 10/31/2019 20:53:42.660 , ModifyDate: 11/01/2019 09:57:48.983 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContractPricing](
	[HairSystemVendorContractPricingID] [int] IDENTITY(1,1) NOT NULL,
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
	[IsContractPriceInActive] [bit] NOT NULL,
	[AddOnSignatureHairlineCost] [money] NOT NULL,
	[AddOnExtendedLaceCost] [money] NOT NULL,
	[AddOnOmbreCost] [money] NOT NULL
) ON [PRIMARY]
GO
