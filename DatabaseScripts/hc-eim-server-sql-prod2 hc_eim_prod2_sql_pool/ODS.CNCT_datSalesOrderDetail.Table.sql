/****** Object:  Table [ODS].[CNCT_datSalesOrderDetail]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_datSalesOrderDetail]
(
	[SalesOrderDetailGUID] [nvarchar](max) NULL,
	[TransactionNumber_Temp] [int] NULL,
	[SalesOrderGUID] [nvarchar](max) NULL,
	[SalesCodeID] [int] NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](21, 6) NULL,
	[Discount] [decimal](19, 4) NULL,
	[Tax1] [decimal](19, 4) NULL,
	[Tax2] [decimal](19, 4) NULL,
	[TaxRate1] [decimal](6, 5) NULL,
	[TaxRate2] [decimal](6, 5) NULL,
	[IsRefundedFlag] [bit] NULL,
	[RefundedSalesOrderDetailGUID] [nvarchar](max) NULL,
	[RefundedTotalQuantity] [int] NULL,
	[RefundedTotalPrice] [decimal](19, 4) NULL,
	[Employee1GUID] [nvarchar](max) NULL,
	[Employee2GUID] [nvarchar](max) NULL,
	[Employee3GUID] [nvarchar](max) NULL,
	[Employee4GUID] [nvarchar](max) NULL,
	[PreviousClientMembershipGUID] [nvarchar](max) NULL,
	[NewCenterID] [int] NULL,
	[ExtendedPriceCalc] [decimal](33, 6) NULL,
	[TotalTaxCalc] [decimal](19, 4) NULL,
	[PriceTaxCalc] [decimal](35, 6) NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[Center_Temp] [int] NULL,
	[performer_temp] [nvarchar](max) NULL,
	[performer2_temp] [nvarchar](max) NULL,
	[Member1Price_temp] [decimal](21, 6) NULL,
	[CancelReasonID] [int] NULL,
	[EntrySortOrder] [int] NULL,
	[HairSystemOrderGUID] [nvarchar](max) NULL,
	[DiscountTypeID] [int] NULL,
	[BenefitTrackingEnabledFlag] [bit] NULL,
	[MembershipPromotionID] [int] NULL,
	[MembershipOrderReasonID] [int] NULL,
	[MembershipNotes] [nvarchar](max) NULL,
	[GenericSalesCodeDescription] [nvarchar](max) NULL,
	[SalesCodeSerialNumber] [nvarchar](max) NULL,
	[WriteOffSalesOrderDetailGUID] [nvarchar](max) NULL,
	[NSFBouncedDate] [datetime2](7) NULL,
	[IsWrittenOffFlag] [bit] NULL,
	[InterCompanyPrice] [decimal](19, 4) NULL,
	[TaxType1ID] [int] NULL,
	[TaxType2ID] [int] NULL,
	[ClientMembershipAddOnID] [int] NULL,
	[NCCMembershipPromotionID] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
