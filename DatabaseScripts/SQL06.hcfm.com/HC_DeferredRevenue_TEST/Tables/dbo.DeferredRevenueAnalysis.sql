CREATE TABLE [dbo].[DeferredRevenueAnalysis](
	[RecordID] [int] IDENTITY(1,1) NOT NULL,
	[CenterSSID] [int] NULL,
	[DateDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[MembershipDescription] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipRate] [money] NULL,
	[Deferred] [money] NULL,
	[Revenue] [money] NULL,
	[TotalPayments] [money] NULL
) ON [PRIMARY]
