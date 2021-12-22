/* CreateDate: 12/29/2018 19:56:07.223 , ModifyDate: 12/29/2018 19:56:07.223 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgCenterMembership_bkup](
	[CenterMembershipID] [int] IDENTITY(1,1) NOT NULL,
	[CenterID] [int] NOT NULL,
	[MembershipID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ContractPriceMale] [money] NULL,
	[ContractPriceFemale] [money] NULL,
	[NumRenewalDays] [int] NULL,
	[AgreementID] [int] NULL,
	[CanUseInHousePaymentPlan] [bit] NOT NULL,
	[DownpaymentMinimumAmount] [money] NULL,
	[MinNumberOfPayments] [int] NULL,
	[MaxNumberOfPayments] [int] NULL,
	[MinimumPaymentPlanAmount] [money] NULL
) ON [PRIMARY]
GO
