CREATE TABLE [dbo].[mktemp_DecPricingUpdates](
	[ClientGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[ClientIdentifier] [int] NULL,
	[MembershipID] [int] NULL,
	[ClientMembershipStatusID] [bit] NULL,
	[MonthlyFee] [money] NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[New Price] [money] NULL
) ON [FG1]
