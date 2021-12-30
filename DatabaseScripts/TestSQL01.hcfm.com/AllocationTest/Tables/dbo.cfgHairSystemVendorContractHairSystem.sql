/* CreateDate: 11/01/2019 09:34:53.383 , ModifyDate: 11/01/2019 09:34:53.470 */
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
