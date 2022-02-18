/* CreateDate: 02/10/2009 08:50:38.477 , ModifyDate: 02/02/2022 08:16:45.537 */
GO
CREATE TABLE [dbo].[cfgCenterTaxRate](
	[CenterTaxRateID] [int] NOT NULL,
	[CenterID] [int] NOT NULL,
	[TaxTypeID] [int] NULL,
	[TaxRate] [decimal](6, 5) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[TaxIdNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cfgCenterTaxRate] PRIMARY KEY CLUSTERED
(
	[CenterTaxRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgCenterTaxRate] ADD  CONSTRAINT [DF_cfgCenterTaxRate_TaxRate]  DEFAULT ((0)) FOR [TaxRate]
GO
ALTER TABLE [dbo].[cfgCenterTaxRate] ADD  CONSTRAINT [DF_cfgCenterTaxRate_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgCenterTaxRate]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterTaxRate_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgCenterTaxRate] CHECK CONSTRAINT [FK_cfgCenterTaxRate_cfgCenter]
GO
ALTER TABLE [dbo].[cfgCenterTaxRate]  WITH CHECK ADD  CONSTRAINT [FK_cfgCenterTaxRate_lkpTaxType] FOREIGN KEY([TaxTypeID])
REFERENCES [dbo].[lkpTaxType] ([TaxTypeID])
GO
ALTER TABLE [dbo].[cfgCenterTaxRate] CHECK CONSTRAINT [FK_cfgCenterTaxRate_lkpTaxType]
GO
