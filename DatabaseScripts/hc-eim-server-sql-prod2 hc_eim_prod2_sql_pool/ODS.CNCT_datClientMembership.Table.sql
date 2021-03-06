/****** Object:  Table [ODS].[CNCT_datClientMembership]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_datClientMembership]
(
	[ClientMembershipGUID] [varchar](8000) NULL,
	[Member1_ID_Temp] [int] NULL,
	[ClientGUID] [varchar](8000) NULL,
	[CenterID] [int] NULL,
	[MembershipID] [int] NULL,
	[ClientMembershipStatusID] [int] NULL,
	[ContractPrice] [numeric](19, 4) NULL,
	[ContractPaidAmount] [numeric](19, 4) NULL,
	[MonthlyFee] [numeric](19, 4) NULL,
	[BeginDate] [date] NULL,
	[EndDate] [date] NULL,
	[MembershipCancelReasonID] [int] NULL,
	[CancelDate] [datetime2](7) NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[IsRenewalFlag] [bit] NULL,
	[IsMultipleSurgeryFlag] [bit] NULL,
	[RenewalCount] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[ClientMembershipIdentifier] [varchar](8000) NULL,
	[MembershipCancelReasonDescription] [varchar](8000) NULL,
	[HasInHousePaymentPlan] [bit] NULL,
	[NationalMonthlyFee] [numeric](19, 4) NULL,
	[MembershipProfileTypeID] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
