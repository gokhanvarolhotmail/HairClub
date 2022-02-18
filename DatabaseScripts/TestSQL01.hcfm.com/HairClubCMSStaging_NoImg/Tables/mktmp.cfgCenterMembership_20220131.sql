/* CreateDate: 01/31/2022 08:36:19.747 , ModifyDate: 02/07/2022 11:03:13.540 */
GO
CREATE TABLE [mktmp].[cfgCenterMembership_20220131](
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
	[MinimumPaymentPlanAmount] [money] NULL,
	[DoesNewBusinessHairOrderRestrictionsApply] [bit] NOT NULL,
	[ValuationPrice] [money] NULL
) ON [PRIMARY]
GO
