/* CreateDate: 05/05/2020 17:42:42.517 , ModifyDate: 05/05/2020 17:43:00.863 */
GO
CREATE TABLE [dbo].[cfgHairSystemCenterContract](
	[HairSystemCenterContractID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
