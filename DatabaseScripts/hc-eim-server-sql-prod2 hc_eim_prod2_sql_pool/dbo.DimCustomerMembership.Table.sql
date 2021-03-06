/****** Object:  Table [dbo].[DimCustomerMembership]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCustomerMembership]
(
	[CustomerMembershipKey] [int] IDENTITY(1,1) NOT NULL,
	[CustomerMembershipID] [nvarchar](200) NULL,
	[CustomerKey] [int] NOT NULL,
	[CustomerID] [nvarchar](200) NULL,
	[CenterKey] [int] NOT NULL,
	[CenterID] [int] NULL,
	[MembershipKey] [int] NOT NULL,
	[MembershipID] [int] NULL,
	[CustomerMembershipStatusID] [int] NULL,
	[CustomerMembershipStatusName] [nvarchar](200) NULL,
	[CustomerMembershipStatusNameShort] [nvarchar](200) NULL,
	[Member1_ID_Temp] [int] NULL,
	[CustomerMembershipContractPrice] [numeric](19, 4) NULL,
	[CustomerMembershipContractPaidAmount] [numeric](19, 4) NULL,
	[CustomerMembershipMonthlyFee] [numeric](19, 4) NULL,
	[CustomerMembershipBeginDateKey] [int] NOT NULL,
	[CustomerMembershipBeginDate] [date] NULL,
	[CustomerMembershipEndDateKey] [int] NOT NULL,
	[CustomerMembershipEndDate] [date] NULL,
	[CustomerMembershipCancelDateKey] [int] NOT NULL,
	[CustomerMembershipCancelDate] [date] NULL,
	[CustomerMembershipCancelReasonID] [int] NULL,
	[CustomerMembershipCancelReasonName] [nvarchar](100) NULL,
	[CustomerMembershipIdentifier] [nvarchar](200) NULL,
	[NationalMonthlyFee] [numeric](19, 4) NULL,
	[CustomerMembershipCreateDate] [datetime] NULL,
	[CustomerMembershipLastUpdateDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[SourceSystem] [nvarchar](100) NOT NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[CustomerMembershipKey] ASC
	)
)
GO
