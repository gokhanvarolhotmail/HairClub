/* CreateDate: 10/31/2019 20:53:42.540 , ModifyDate: 11/01/2019 09:57:48.980 */
GO
CREATE TABLE [dbo].[cfgHairSystemVendorContract](
	[HairSystemVendorContractID] [int] IDENTITY(1,1) NOT NULL,
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
	[IsRepair] [bit] NULL
) ON [PRIMARY]
GO
