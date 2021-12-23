/* CreateDate: 02/10/2009 13:32:54.470 , ModifyDate: 12/21/2020 07:17:09.323 */
GO
CREATE TABLE [dbo].[cfgSalesCode](
	[SalesCodeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[SalesCodeSortOrder] [int] NULL,
	[SalesCodeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesCodeTypeID] [int] NULL,
	[SalesCodeDepartmentID] [int] NULL,
	[VendorID] [int] NULL,
	[Barcode] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PriceDefault] [money] NULL,
	[GLNumber] [int] NULL,
	[ServiceDuration] [int] NULL,
	[CanScheduleFlag] [bit] NULL,
	[FactoryOrderFlag] [bit] NULL,
	[IsRefundableFlag] [bit] NULL,
	[InventoryFlag] [bit] NULL,
	[SurgeryCloseoutFlag] [bit] NULL,
	[TechnicalProfileFlag] [bit] NULL,
	[AdjustContractPaidAmountFlag] [bit] NULL,
	[IsPriceAdjustableFlag] [bit] NULL,
	[IsDiscountableFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsARTenderRequiredFlag] [bit] NULL,
	[CanOrderFlag] [bit] NULL,
	[IsQuantityAdjustableFlag] [bit] NULL,
	[IsPhotoEnabledFlag] [bit] NULL,
	[IsEXTOnlyProductFlag] [bit] NULL,
	[HairSystemID] [int] NULL,
	[SaleCount] [int] NULL,
	[IsSalesCodeKitFlag] [bit] NULL,
	[BIOGeneralLedgerID] [int] NULL,
	[EXTGeneralLedgerID] [int] NULL,
	[SURGeneralLedgerID] [int] NULL,
	[BrandID] [int] NULL,
	[Product] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Size] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsRefundablePayment] [bit] NOT NULL,
	[IsNSFChargebackFee] [bit] NULL,
	[InterCompanyPrice] [money] NULL,
	[IsQuantityRequired] [bit] NOT NULL,
	[XTRGeneralLedgerID] [int] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsBosleySalesCode] [bit] NOT NULL,
	[IsVisibleToConsultant] [bit] NOT NULL,
	[IsSerialized] [bit] NOT NULL,
	[SerialNumberRegEx] [nvarchar](300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[QuantityPerPack] [int] NULL,
	[PackUnitOfMeasureID] [int] NULL,
	[InventorySalesCodeID] [int] NULL,
	[IsVisibleToClient] [bit] NOT NULL,
	[CanBeManagedByClient] [bit] NOT NULL,
	[IsManagedByClientOnly] [bit] NOT NULL,
	[ClientDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MDPGeneralLedgerID] [int] NULL,
	[PackSKU] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsBackBarApproved] [bit] NULL,
 CONSTRAINT [PK_cfgSalesCode] PRIMARY KEY CLUSTERED
(
	[SalesCodeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCode_IsActive_CanScheduleFlag_SalesCodeID] ON [dbo].[cfgSalesCode]
(
	[IsActiveFlag] ASC,
	[CanScheduleFlag] ASC,
	[SalesCodeID] ASC
)
INCLUDE([SalesCodeDescription],[SalesCodeDescriptionShort],[ServiceDuration]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCode_SalesCodeDepartmentID] ON [dbo].[cfgSalesCode]
(
	[SalesCodeDepartmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCode_SalesCodeDescription] ON [dbo].[cfgSalesCode]
(
	[SalesCodeDescription] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCode_SalesCodeDescriptionShort] ON [dbo].[cfgSalesCode]
(
	[SalesCodeDescriptionShort] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_SalesCode_ID_Desc] ON [dbo].[cfgSalesCode]
(
	[SalesCodeID] ASC
)
INCLUDE([SalesCodeDescription],[ServiceDuration]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_PriceDefault]  DEFAULT ((0)) FOR [PriceDefault]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_CanScheduleFlag]  DEFAULT ((0)) FOR [CanScheduleFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_FactoryOrderFlag]  DEFAULT ((0)) FOR [FactoryOrderFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_IsRefundableFlag]  DEFAULT ((0)) FOR [IsRefundableFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_InventoryFlag]  DEFAULT ((0)) FOR [InventoryFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_SurgeryCloseoutFlag]  DEFAULT ((0)) FOR [SurgeryCloseoutFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_TechnicalProfileFlag]  DEFAULT ((0)) FOR [TechnicalProfileFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_AdjustContractPaidAmountFlag]  DEFAULT ((0)) FOR [AdjustContractPaidAmountFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_IsPriceAdjustableFlag]  DEFAULT ((0)) FOR [IsPriceAdjustableFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_IsDiscountableFlag]  DEFAULT ((0)) FOR [IsDiscountableFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_CanOrderFlag]  DEFAULT ((1)) FOR [CanOrderFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((1)) FOR [IsQuantityAdjustableFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [IsPhotoEnabledFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [IsEXTOnlyProductFlag]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [SaleCount]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [IsRefundablePayment]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [IsQuantityRequired]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [IsBosleySalesCode]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  CONSTRAINT [DF_cfgSalesCode_IsVisibleToConsultant]  DEFAULT ((0)) FOR [IsVisibleToConsultant]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [IsSerialized]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [IsVisibleToClient]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [CanBeManagedByClient]
GO
ALTER TABLE [dbo].[cfgSalesCode] ADD  DEFAULT ((0)) FOR [IsManagedByClientOnly]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_cfgHairSystem] FOREIGN KEY([HairSystemID])
REFERENCES [dbo].[cfgHairSystem] ([HairSystemID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_cfgHairSystem]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_cfgSalesCode] FOREIGN KEY([InventorySalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_cfgSalesCode]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_cfgVendor] FOREIGN KEY([VendorID])
REFERENCES [dbo].[cfgVendor] ([VendorID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_cfgVendor]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_lkpBrand] FOREIGN KEY([BrandID])
REFERENCES [dbo].[lkpBrand] ([BrandID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_lkpBrand]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger] FOREIGN KEY([GLNumber])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger1] FOREIGN KEY([BIOGeneralLedgerID])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger1]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger2] FOREIGN KEY([EXTGeneralLedgerID])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger2]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger3] FOREIGN KEY([SURGeneralLedgerID])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger3]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger4] FOREIGN KEY([XTRGeneralLedgerID])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_lkpGeneralLedger4]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_lkpSalesCodeDepartment] FOREIGN KEY([SalesCodeDepartmentID])
REFERENCES [dbo].[lkpSalesCodeDepartment] ([SalesCodeDepartmentID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_lkpSalesCodeDepartment]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_lkpSalesCodeType] FOREIGN KEY([SalesCodeTypeID])
REFERENCES [dbo].[lkpSalesCodeType] ([SalesCodeTypeID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_lkpSalesCodeType]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH CHECK ADD  CONSTRAINT [FK_cfgSalesCode_lkpUnitOfMeasure] FOREIGN KEY([PackUnitOfMeasureID])
REFERENCES [dbo].[lkpUnitOfMeasure] ([UnitOfMeasureID])
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_lkpUnitOfMeasure]
GO
