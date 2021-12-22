/* CreateDate: 12/31/2010 13:20:58.187 , ModifyDate: 05/26/2020 10:49:41.430 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgHairSystemCenterContract](
	[HairSystemCenterContractID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NOT NULL,
	[ContractEntryDate] [datetime] NOT NULL,
	[ContractBeginDate] [datetime] NOT NULL,
	[ContractEndDate] [datetime] NOT NULL,
	[IsActiveContract] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsRepair] [bit] NOT NULL,
	[IsPriorityContract] [bit] NOT NULL,
 CONSTRAINT [PK_cfgHairSystemCenterContract] PRIMARY KEY CLUSTERED
(
	[HairSystemCenterContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgHairSystemCenterContract] ON [dbo].[cfgHairSystemCenterContract]
(
	[CenterID] ASC,
	[ContractBeginDate] DESC,
	[ContractEntryDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContract] ADD  DEFAULT ((0)) FOR [IsActiveContract]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContract] ADD  CONSTRAINT [DF_cfgHairSystemCenterContract_IsPriorityContract]  DEFAULT ((0)) FOR [IsPriorityContract]
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContract]  WITH CHECK ADD  CONSTRAINT [FK_cfgHairSystemCenterContract_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgHairSystemCenterContract] CHECK CONSTRAINT [FK_cfgHairSystemCenterContract_cfgCenter]
GO
