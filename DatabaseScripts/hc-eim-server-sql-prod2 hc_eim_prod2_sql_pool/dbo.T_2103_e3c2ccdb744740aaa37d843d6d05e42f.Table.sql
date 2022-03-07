/****** Object:  Table [dbo].[T_2103_e3c2ccdb744740aaa37d843d6d05e42f]    Script Date: 3/7/2022 8:42:23 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2103_e3c2ccdb744740aaa37d843d6d05e42f]
(
	[OrderDate] [datetime2](7) NULL,
	[OrderDateKey] [int] NULL,
	[OrderTimeOfDayKey] [int] NULL,
	[OrderId] [nvarchar](max) NULL,
	[OrderDetailId] [nvarchar](max) NULL,
	[SalesCodeId] [int] NULL,
	[SalesCodeKey] [int] NULL,
	[SalesCodeDepartmentId] [int] NULL,
	[SalesCodeDepartmentKey] [int] NULL,
	[OrderTypeId] [int] NULL,
	[OrderTypeKey] [int] NULL,
	[CenterId] [int] NULL,
	[CenterKey] [int] NULL,
	[OrderUserId] [nvarchar](max) NULL,
	[OrderUserKey] [int] NULL,
	[OrderQuantity] [int] NULL,
	[OrderExtendedPriceCalc] [decimal](21, 6) NULL,
	[OrderPrice] [decimal](21, 6) NULL,
	[OrderDiscount] [decimal](21, 6) NULL,
	[OrderTax1] [decimal](21, 6) NULL,
	[OrderTax2] [decimal](21, 6) NULL,
	[OrderTaxRate1] [decimal](21, 6) NULL,
	[OrderTaxRate2] [decimal](21, 6) NULL,
	[ContBalMoneyAdjustment] [decimal](23, 6) NULL,
	[ContBalQuantityTotalChange] [int] NULL,
	[ContBalMoneyChange] [decimal](23, 6) NULL,
	[GraftsMoneyAdjustment] [decimal](23, 6) NULL,
	[GraftsQuantityTotalChange] [int] NULL,
	[GraftsMoneyChange] [decimal](23, 6) NULL,
	[PPSGMoneyAdjustment] [decimal](23, 6) NULL,
	[PPSGQuantityTotalChange] [int] NULL,
	[PPSGMoneyChange] [decimal](23, 6) NULL,
	[IsVoided] [bit] NULL,
	[IsClosed] [bit] NULL,
	[IsGuarantee] [bit] NULL,
	[PreviousCustomerMembershipId] [nvarchar](max) NULL,
	[PreviousCustomerMembershipKey] [int] NULL,
	[PreviousMembershipKey] [int] NULL,
	[PreviousMembershipId] [int] NULL,
	[CustomerMembershipId] [nvarchar](max) NULL,
	[CustomerMembershipKey] [int] NULL,
	[MembershipId] [int] NULL,
	[MembershipKey] [int] NULL,
	[CustomerId] [nvarchar](max) NULL,
	[CustomerKey] [int] NULL,
	[GeographyKey] [int] NULL,
	[GenderId] [int] NULL,
	[Genderkey] [int] NULL,
	[LanguageId] [int] NULL,
	[LanguageKey] [int] NULL,
	[AppointmentId] [nvarchar](max) NULL,
	[IsRefunded] [bit] NULL,
	[r8bcca77ec4b84580965ee130109bd73d] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
