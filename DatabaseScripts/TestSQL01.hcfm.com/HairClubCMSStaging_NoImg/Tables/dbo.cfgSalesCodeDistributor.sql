/* CreateDate: 05/28/2018 22:15:34.310 , ModifyDate: 02/04/2022 21:19:14.913 */
GO
CREATE TABLE [dbo].[cfgSalesCodeDistributor](
	[SalesCodeDistributorID] [int] IDENTITY(1,1) NOT NULL,
	[SalesCodeID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[ItemSKU] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PackSKU] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ItemName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ItemDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActive] [bit] NOT NULL,
	[QuantityAvailable] [int] NOT NULL,
	[AllowDropShipments] [bit] NOT NULL,
	[AllowCenterOrder] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_cfgSalesCodeDistributor] PRIMARY KEY CLUSTERED
(
	[SalesCodeDistributorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgSalesCodeDistributor]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeDistributor_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgSalesCodeDistributor] CHECK CONSTRAINT [FK_cfgSalesCodeDistributor_cfgCenter]
GO
ALTER TABLE [dbo].[cfgSalesCodeDistributor]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeDistributor_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgSalesCodeDistributor] CHECK CONSTRAINT [FK_cfgSalesCodeDistributor_cfgSalesCode]
GO
