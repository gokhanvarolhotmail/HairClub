/****** Object:  Table [dbo].[FactCancelations]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactCancelations]
(
	[FactDatekey] [int] NULL,
	[FactDate] [datetime] NULL,
	[LocalDateKey] [int] NULL,
	[LocalDate] [datetime] NULL,
	[TimezoneKey] [int] NULL,
	[TimeZoneID] [int] NULL,
	[InvoiceNumber] [varchar](100) NULL,
	[LeadKey] [int] NULL,
	[LeadId] [varchar](100) NULL,
	[AccountKey] [int] NULL,
	[AccountId] [int] NULL,
	[CustomerKey] [int] NULL,
	[CustomerId] [int] NULL,
	[GeographyKey] [int] NULL,
	[ZipCodeId] [varchar](200) NULL,
	[RevenueGroupkey] [int] NULL,
	[RevenueGroupId] [int] NULL,
	[CenterKey] [int] NULL,
	[CenterId] [int] NULL,
	[BusinessSegmentKey] [int] NULL,
	[BusinessSegmentId] [int] NULL,
	[MembershipKey] [int] NULL,
	[MembershipId] [int] NULL,
	[CancellationReasonKey] [int] NULL,
	[CancellationReasonId] [int] NULL,
	[MembershipStartDate] [datetime] NULL,
	[MembershipEndDate] [datetime] NULL,
	[MembershipCancelDate] [datetime] NULL,
	[MonthlyFee] [int] NULL,
	[ContractPrice] [int] NULL,
	[IsMembershipChange] [bit] NULL,
	[IsCancellation] [bit] NULL,
	[IsTermination] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
