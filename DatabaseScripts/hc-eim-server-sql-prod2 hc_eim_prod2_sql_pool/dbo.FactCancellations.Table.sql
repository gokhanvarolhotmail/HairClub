/****** Object:  Table [dbo].[FactCancellations]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactCancellations]
(
	[FactDateKey] [int] NULL,
	[FactDate] [datetime] NULL,
	[LocalDateKey] [int] NULL,
	[LocalDate] [datetime] NULL,
	[TimezoneKey] [int] NULL,
	[TimezoneId] [nvarchar](1024) NULL,
	[InvoiceNumber] [nvarchar](1024) NULL,
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](1024) NULL,
	[AccountKey] [int] NULL,
	[AccountId] [nvarchar](1024) NULL,
	[CustomerKey] [int] NULL,
	[CustomerId] [nvarchar](1024) NULL,
	[GeographyKey] [int] NULL,
	[ZipCodeId] [nvarchar](1024) NULL,
	[RevenueGroupkey] [int] NULL,
	[RevenueGroupId] [nvarchar](1024) NULL,
	[CenterKey] [int] NULL,
	[CenterId] [nvarchar](1024) NULL,
	[CenterNumber] [int] NULL,
	[BusinessSegmentKey] [int] NULL,
	[BusinessSegmentId] [nvarchar](1024) NULL,
	[MembershipKey] [int] NULL,
	[MembershipId] [nvarchar](1024) NULL,
	[CancellationReasonKey] [int] NULL,
	[CancellationReasonId] [nvarchar](1024) NULL,
	[MembershipStartDate] [datetime] NULL,
	[MembershipEndDate] [datetime] NULL,
	[MembershipCancelDate] [datetime] NULL,
	[MonthlyFee] [nvarchar](199) NULL,
	[ContractPrice] [nvarchar](199) NULL,
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
