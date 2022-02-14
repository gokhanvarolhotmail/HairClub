/****** Object:  Table [ODS].[T_2355_2c44a24d64d64fd6b9af3d1c89c88a05]    Script Date: 2/14/2022 11:44:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[T_2355_2c44a24d64d64fd6b9af3d1c89c88a05]
(
	[ClientMembershipGUID] [nvarchar](max) NULL,
	[Member1_ID_Temp] [int] NULL,
	[ClientGUID] [nvarchar](max) NULL,
	[CenterID] [int] NULL,
	[MembershipID] [int] NULL,
	[ClientMembershipStatusID] [int] NULL,
	[ContractPrice] [decimal](19, 4) NULL,
	[ContractPaidAmount] [decimal](19, 4) NULL,
	[MonthlyFee] [decimal](19, 4) NULL,
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
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[ClientMembershipIdentifier] [nvarchar](max) NULL,
	[MembershipCancelReasonDescription] [nvarchar](max) NULL,
	[HasInHousePaymentPlan] [bit] NULL,
	[NationalMonthlyFee] [decimal](19, 4) NULL,
	[MembershipProfileTypeID] [int] NULL,
	[rc02c79ac7fc24685a15e0c214d2ca9c3] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
