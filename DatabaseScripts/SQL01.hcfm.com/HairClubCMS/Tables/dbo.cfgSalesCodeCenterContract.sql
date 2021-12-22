CREATE TABLE [dbo].[cfgSalesCodeCenterContract](
	[SalesCodeCenterContractID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NOT NULL,
	[ContractEntryDate] [datetime] NOT NULL,
	[ContractBeginDate] [datetime] NOT NULL,
	[ContractEndDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgSalesCodeCenterContract] PRIMARY KEY CLUSTERED
(
	[SalesCodeCenterContractID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterContract]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenterContract_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterContract] CHECK CONSTRAINT [FK_cfgSalesCodeCenterContract_cfgCenter]
