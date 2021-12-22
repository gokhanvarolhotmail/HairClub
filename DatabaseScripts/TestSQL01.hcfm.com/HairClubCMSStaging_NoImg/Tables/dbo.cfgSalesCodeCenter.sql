/* CreateDate: 10/29/2008 16:20:56.183 , ModifyDate: 12/03/2021 10:24:48.607 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgSalesCodeCenter](
	[SalesCodeCenterID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterID] [int] NULL,
	[SalesCodeID] [int] NULL,
	[PriceRetail] [money] NULL,
	[TaxRate1ID] [int] NULL,
	[TaxRate2ID] [int] NULL,
	[QuantityMaxLevel] [int] NULL,
	[QuantityMinLevel] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[AgreementID] [int] NULL,
	[CenterCost] [money] NULL,
 CONSTRAINT [PK_cfgSalesCodeCenter] PRIMARY KEY CLUSTERED
(
	[SalesCodeCenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_cfgSalesCodeCenter_CenterID_SalesCodeID_AgreementID] ON [dbo].[cfgSalesCodeCenter]
(
	[CenterID] ASC,
	[SalesCodeID] ASC,
	[AgreementID] ASC
)
INCLUDE([TaxRate1ID],[TaxRate2ID],[SalesCodeCenterID],[IsActiveFlag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeCenter_SalesCodeID] ON [dbo].[cfgSalesCodeCenter]
(
	[SalesCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter] ADD  CONSTRAINT [DF_cfgSalesCodeCenter_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenter_cfgAgreement] FOREIGN KEY([AgreementID])
REFERENCES [dbo].[cfgAgreement] ([AgreementID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter] CHECK CONSTRAINT [FK_cfgSalesCodeCenter_cfgAgreement]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenter_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter] CHECK CONSTRAINT [FK_cfgSalesCodeCenter_cfgCenter]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenter_cfgCenterTaxRate] FOREIGN KEY([TaxRate1ID])
REFERENCES [dbo].[cfgCenterTaxRate] ([CenterTaxRateID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter] CHECK CONSTRAINT [FK_cfgSalesCodeCenter_cfgCenterTaxRate]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenter_cfgCenterTaxRate1] FOREIGN KEY([TaxRate2ID])
REFERENCES [dbo].[cfgCenterTaxRate] ([CenterTaxRateID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter] CHECK CONSTRAINT [FK_cfgSalesCodeCenter_cfgCenterTaxRate1]
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCodeCenter_cfgSalesCode] FOREIGN KEY([SalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgSalesCodeCenter] CHECK CONSTRAINT [FK_cfgSalesCodeCenter_cfgSalesCode]
GO
