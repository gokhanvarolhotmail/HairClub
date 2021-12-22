/* CreateDate: 12/20/2021 16:25:19.267 , ModifyDate: 12/20/2021 16:25:19.267 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datClientMembership_backup](
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[Member1_ID_Temp] [int] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[MembershipID] [int] NULL,
	[ClientMembershipStatusID] [int] NULL,
	[ContractPrice] [money] NULL,
	[ContractPaidAmount] [money] NULL,
	[MonthlyFee] [money] NULL,
	[BeginDate] [date] NULL,
	[EndDate] [date] NULL,
	[MembershipCancelReasonID] [int] NULL,
	[CancelDate] [datetime] NULL,
	[IsGuaranteeFlag] [bit] NULL,
	[IsRenewalFlag] [bit] NULL,
	[IsMultipleSurgeryFlag] [bit] NULL,
	[RenewalCount] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ClientMembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipCancelReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HasInHousePaymentPlan] [bit] NOT NULL,
	[NationalMonthlyFee] [money] NULL,
	[MembershipProfileTypeID] [int] NULL
) ON [PRIMARY]
GO
