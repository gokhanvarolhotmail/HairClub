/* CreateDate: 10/04/2010 12:08:46.230 , ModifyDate: 02/02/2022 10:08:36.740 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContractHairSystem](
	[HairSystemVendorContractHairSystemID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairSystemVendorContractID] [int] NOT NULL,
	[HairSystemID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_cfgHairSystemVendorContractHairSystem] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorContractHairSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemVendorContractHairSystem_HairSystemVendorContractID_HairSystemID] ON [dbo].[cfgHairSystemVendorContractHairSystem]
(
	[HairSystemVendorContractID] DESC,
	[HairSystemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystem]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContractHairSystem_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystem] CHECK CONSTRAINT [FK_cfgHairSystemVendorContractHairSystem_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystem]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContractHairSystem_cfgHairSystemVendorContract] FOREIGN KEY([HairSystemVendorContractID])
REFERENCES [dbo].[cfgHairSystemVendorContract] ([HairSystemVendorContractID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContractHairSystem] CHECK CONSTRAINT [FK_cfgHairSystemVendorContractHairSystem_cfgHairSystemVendorContract]
GO
