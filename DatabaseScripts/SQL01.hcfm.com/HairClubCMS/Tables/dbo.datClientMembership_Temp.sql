/* CreateDate: 09/23/2011 13:43:01.827 , ModifyDate: 10/29/2015 22:39:13.777 */
GO
CREATE TABLE [dbo].[datClientMembership_Temp](
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
	[UpdateStamp] [timestamp] NULL
) ON [PRIMARY]
GO
