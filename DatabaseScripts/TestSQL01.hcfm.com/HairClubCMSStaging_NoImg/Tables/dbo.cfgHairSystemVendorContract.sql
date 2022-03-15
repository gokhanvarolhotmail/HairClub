/* CreateDate: 06/27/2011 20:28:26.157 , ModifyDate: 03/04/2022 16:09:12.680 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContract](
	[HairSystemVendorContractID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[VendorID] [int] NOT NULL,
	[ContractName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ContractEntryDate] [datetime] NOT NULL,
	[ContractBeginDate] [datetime] NOT NULL,
	[ContractEndDate] [datetime] NOT NULL,
	[IsActiveContract] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsRepair] [bit] NULL,
 CONSTRAINT [PK_cfgHairSystemVendorContract] PRIMARY KEY CLUSTERED
(
	[HairSystemVendorContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemVendorContract_ContractEndDate] ON [dbo].[cfgHairSystemVendorContract]
(
	[ContractEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemVendorContract_ContractName] ON [dbo].[cfgHairSystemVendorContract]
(
	[ContractName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContract] ADD  CONSTRAINT [DF_cfgHairSystemVendorContract_IsRepair]  DEFAULT ((0)) FOR [IsRepair]
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContract]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemVendorContract_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgHairSystemVendorContract] CHECK CONSTRAINT [FK_cfgHairSystemVendorContract_cfgVendor]
GO
