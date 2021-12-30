/* CreateDate: 05/05/2020 17:42:38.053 , ModifyDate: 12/21/2020 07:17:20.277 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
ALTER TABLE [dbo].[cfgSalesCode]  WITH NOCHECK ADD  CONSTRAINT [FK_cfgSalesCode_cfgSalesCode] FOREIGN KEY([InventorySalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
NOT FOR REPLICATION
GO
ALTER TABLE [dbo].[cfgSalesCode] CHECK CONSTRAINT [FK_cfgSalesCode_cfgSalesCode]
GO
