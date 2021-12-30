/* CreateDate: 05/28/2018 22:15:34.780 , ModifyDate: 05/28/2018 22:15:34.793 */
GO
CREATE TABLE [dbo].[cfgSalesCodeCenterContractPricing](
	[SalesCodeCenterContractPricingID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SalesCodeCenterContractID] [int] NOT NULL,
	[SalesCodeID] [int] NOT NULL,
	[Price] [money] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgSalesCodeCenterContractPricing] PRIMARY KEY CLUSTERED
(
	[SalesCodeCenterContractPricingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterContractPricing]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenterContractPricing_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterContractPricing] CHECK CONSTRAINT [FK_cfgSalesCodeCenterContractPricing_cfgSalesCode]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterContractPricing]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenterContractPricing_cfgSalesCodeCenterContract] FOREIGN KEY([SalesCodeCenterContractID])
REFERENCES [dbo].[cfgSalesCodeCenterContract] ([SalesCodeCenterContractID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenterContractPricing] CHECK CONSTRAINT [FK_cfgSalesCodeCenterContractPricing_cfgSalesCodeCenterContract]
GO
