CREATE TABLE [dbo].[tmp_DecPricing](
	[ClientGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[ClientIdentifier] [int] NULL,
	[MembershipID] [int] NULL,
	[ClientMembershipStatusID] [smallint] NULL,
	[MonthlyFee] [money] NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[NewPrice] [money] NULL
) ON [PRIMARY]
