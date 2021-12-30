/* CreateDate: 05/05/2020 17:42:44.157 , ModifyDate: 05/05/2020 18:41:07.400 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContract](
	[HairSystemVendorContractID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
