/****** Object:  Table [ODS].[CNCT_PaymentSalesCode]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_PaymentSalesCode]
(
	[SalesCodeID] [int] NULL,
	[SalesCodeSortOrder] [int] NULL,
	[SalesCodeDescription] [varchar](8000) NULL,
	[SalesCodeDescriptionShort] [varchar](8000) NULL,
	[SalesCodeTypeID] [int] NULL,
	[SalesCodeDepartmentID] [int] NULL,
	[VendorID] [int] NULL,
	[Barcode] [varchar](8000) NULL,
	[PriceDefault] [numeric](19, 4) NULL,
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
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
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
	[Product] [varchar](8000) NULL,
	[Size] [varchar](8000) NULL,
	[IsRefundablePayment] [bit] NULL,
	[IsNSFChargebackFee] [bit] NULL,
	[InterCompanyPrice] [numeric](19, 4) NULL,
	[IsQuantityRequired] [bit] NULL,
	[XTRGeneralLedgerID] [int] NULL,
	[DescriptionResourceKey] [varchar](8000) NULL,
	[IsBosleySalesCode] [bit] NULL,
	[IsVisibleToConsultant] [bit] NULL,
	[IsSerialized] [bit] NULL,
	[SerialNumberRegEx] [varchar](8000) NULL,
	[QuantityPerPack] [int] NULL,
	[PackUnitOfMeasureID] [int] NULL,
	[InventorySalesCodeID] [int] NULL,
	[IsVisibleToClient] [bit] NULL,
	[CanBeManagedByClient] [bit] NULL,
	[IsManagedByClientOnly] [bit] NULL,
	[ClientDescription] [varchar](8000) NULL,
	[MDPGeneralLedgerID] [int] NULL,
	[PackSKU] [varchar](8000) NULL,
	[IsBackBarApproved] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
