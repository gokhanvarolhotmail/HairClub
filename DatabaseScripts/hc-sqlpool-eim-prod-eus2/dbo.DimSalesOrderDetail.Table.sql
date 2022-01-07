/****** Object:  Table [dbo].[DimSalesOrderDetail]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimSalesOrderDetail]
(
	[SalesOrderDetailKey] [int] IDENTITY(1,1) NOT NULL,
	[SalesOrderDetailID] [uniqueidentifier] NULL,
	[TransactionNumber_Temp] [int] NULL,
	[SalesOrderKey] [int] NULL,
	[SalesOrderID] [uniqueidentifier] NULL,
	[SalesCodeKey] [int] NULL,
	[SalesCodeID] [int] NULL,
	[SalesCodeDescription] [nvarchar](50) NULL,
	[SalesCodeDescriptionShort] [nvarchar](15) NULL,
	[IsVoidedFlag] [bit] NULL,
	[IsClosedFlag] [bit] NULL,
	[Quantity] [int] NULL,
	[Price] [money] NULL,
	[Discount] [money] NULL,
	[Tax1] [money] NULL,
	[Tax2] [money] NULL,
	[TaxRate1] [money] NULL,
	[TaxRate2] [money] NULL,
	[ExtendedPriceCalc] [money] NULL,
	[TotalTaxCalc] [money] NULL,
	[PriceTaxCalc] [money] NULL,
	[IsRefundedFlag] [bit] NULL,
	[RefundedSalesOrderDetailID] [uniqueidentifier] NULL,
	[RefundedTotalQuantity] [int] NULL,
	[RefundedTotalPrice] [money] NULL,
	[Employee1ID] [uniqueidentifier] NULL,
	[Employee1FullName] [nvarchar](50) NULL,
	[Employee1FirstName] [nvarchar](50) NULL,
	[Employee1LastName] [nvarchar](50) NULL,
	[Employee1Initials] [nvarchar](5) NULL,
	[Employee2ID] [uniqueidentifier] NULL,
	[Employee2FullName] [nvarchar](50) NULL,
	[Employee2FirstName] [nvarchar](50) NULL,
	[Employee2LastName] [nvarchar](50) NULL,
	[Employee2Initials] [nvarchar](5) NULL,
	[Employee3ID] [uniqueidentifier] NULL,
	[Employee3FirstName] [nvarchar](50) NULL,
	[Employee3LastName] [nvarchar](50) NULL,
	[Employee3Initials] [nvarchar](5) NULL,
	[Employee4ID] [uniqueidentifier] NULL,
	[Employee4FullName] [nvarchar](50) NULL,
	[Employee4FirstName] [nvarchar](50) NULL,
	[Employee4LastName] [nvarchar](50) NULL,
	[Employee4Initials] [nvarchar](5) NULL,
	[PreviousClientMembershipID] [uniqueidentifier] NULL,
	[NewCenterID] [int] NULL,
	[Performer2_temp] [varchar](50) NULL,
	[Member1Price_Temp] [money] NULL,
	[CancelReasonID] [int] NULL,
	[employee3fullname] [nvarchar](50) NULL,
	[MembershipOrderReasonID] [int] NULL,
	[MembershipPromotionID] [int] NULL,
	[HairSystemOrderID] [uniqueidentifier] NULL,
	[ClientMembershipAddOnID] [int] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[SalesOrderDetailID] ASC
	)
)
GO
