/* CreateDate: 03/26/2014 08:01:07.810 , ModifyDate: 05/26/2020 10:49:36.017 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContractHairSystemDensity](
	[HairSystemVendorContractHairSystemDensityID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemVendorContractID] [int] NOT NULL,
	[HairSystemDensityID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemVendorContractHairSystemDensity] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorContractHairSystemDensityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystemDensity]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContractHairSystemDensity_cfgHairSystemVendorContract] FOREIGN KEY([HairSystemVendorContractID])
REFERENCES [dbo].[cfgHairSystemVendorContract] ([HairSystemVendorContractID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystemDensity] CHECK CONSTRAINT [FK_cfgHairSystemVendorContractHairSystemDensity_cfgHairSystemVendorContract]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystemDensity]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContractHairSystemDensity_lkpHairSystemDensity] FOREIGN KEY([HairSystemDensityID])
REFERENCES [dbo].[lkpHairSystemDensity] ([HairSystemDensityID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystemDensity] CHECK CONSTRAINT [FK_cfgHairSystemVendorContractHairSystemDensity_lkpHairSystemDensity]
GO
