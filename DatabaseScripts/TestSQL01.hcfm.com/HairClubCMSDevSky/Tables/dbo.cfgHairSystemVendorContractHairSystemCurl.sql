/* CreateDate: 10/04/2010 12:08:46.240 , ModifyDate: 12/29/2021 15:38:46.350 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContractHairSystemCurl](
	[HairSystemVendorContractHairSystemCurlID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemVendorContractID] [int] NOT NULL,
	[HairSystemCurlID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemVendorContractHairSystemCurl] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorContractHairSystemCurlID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystemCurl]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContractHairSystemCurl_cfgHairSystemVendorContract] FOREIGN KEY([HairSystemVendorContractID])
REFERENCES [dbo].[cfgHairSystemVendorContract] ([HairSystemVendorContractID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystemCurl] CHECK CONSTRAINT [FK_cfgHairSystemVendorContractHairSystemCurl_cfgHairSystemVendorContract]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystemCurl]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContractHairSystemCurl_lkpHairSystemCurl] FOREIGN KEY([HairSystemCurlID])
REFERENCES [dbo].[lkpHairSystemCurl] ([HairSystemCurlID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystemCurl] CHECK CONSTRAINT [FK_cfgHairSystemVendorContractHairSystemCurl_lkpHairSystemCurl]
GO
