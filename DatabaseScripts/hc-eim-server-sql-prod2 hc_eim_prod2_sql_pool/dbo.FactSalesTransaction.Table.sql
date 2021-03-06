/****** Object:  Table [dbo].[FactSalesTransaction]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactSalesTransaction]
(
	[OrderDate] [datetime] NULL,
	[OrderDateKey] [int] NULL,
	[OrderTimeOfDayKey] [int] NULL,
	[OrderId] [nvarchar](250) NULL,
	[OrderDetailId] [nvarchar](250) NULL,
	[SalesCodeId] [int] NULL,
	[SalesCodeKey] [int] NULL,
	[SalesCodeDepartmentId] [int] NULL,
	[SalesCodeDepartmentKey] [int] NULL,
	[OrderTypeId] [int] NULL,
	[OrderTypeKey] [int] NULL,
	[CenterId] [int] NULL,
	[CenterKey] [int] NULL,
	[OrderUserId] [nvarchar](250) NULL,
	[OrderUserKey] [int] NULL,
	[OrderQuantity] [int] NULL,
	[OrderExtendedPriceCalc] [decimal](21, 6) NULL,
	[OrderPrice] [decimal](21, 6) NULL,
	[OrderDiscount] [decimal](21, 6) NULL,
	[OrderTax1] [decimal](21, 6) NULL,
	[OrderTax2] [decimal](21, 6) NULL,
	[OrderTaxRate1] [decimal](21, 6) NULL,
	[OrderTaxRate2] [decimal](21, 6) NULL,
	[ContBalMoneyAdjustment] [numeric](23, 6) NULL,
	[ContBalQuantityTotalChange] [int] NULL,
	[ContBalMoneyChange] [numeric](23, 6) NULL,
	[GraftsMoneyAdjustment] [numeric](23, 6) NULL,
	[GraftsQuantityTotalChange] [int] NULL,
	[GraftsMoneyChange] [numeric](23, 6) NULL,
	[PPSGMoneyAdjustment] [numeric](23, 6) NULL,
	[PPSGQuantityTotalChange] [int] NULL,
	[PPSGMoneyChange] [numeric](23, 6) NULL,
	[IsVoided] [bit] NULL,
	[IsClosed] [bit] NULL,
	[IsGuarantee] [bit] NULL,
	[PreviousCustomerMembershipId] [nvarchar](250) NULL,
	[PreviousCustomerMembershipKey] [int] NULL,
	[PreviousMembershipKey] [int] NULL,
	[PreviousMembershipId] [int] NULL,
	[CustomerMembershipId] [nvarchar](250) NULL,
	[CustomerMembershipKey] [int] NULL,
	[MembershipId] [int] NULL,
	[MembershipKey] [int] NULL,
	[CustomerId] [nvarchar](250) NULL,
	[CustomerKey] [int] NULL,
	[GeographyKey] [int] NULL,
	[GenderId] [int] NULL,
	[Genderkey] [int] NULL,
	[LanguageId] [int] NULL,
	[LanguageKey] [int] NULL,
	[LeadId] [nvarchar](250) NULL,
	[LeadKey] [int] NULL,
	[AccountId] [nvarchar](250) NULL,
	[AccountKey] [int] NULL,
	[AppointmentId] [nvarchar](200) NULL,
	[IsRefunded] [bit] NULL,
	[PerformerId] [nvarchar](200) NULL,
	[PerformerName] [nvarchar](200) NULL,
	[ServiceAppointmentId] [nvarchar](200) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
