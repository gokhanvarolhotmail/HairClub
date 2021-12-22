CREATE TABLE [dbo].[MembershipRatesImport](
	[centerid] [float] NULL,
	[CenterName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipAdditional] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FeeSequence] [float] NULL,
	[Rate] [float] NULL,
	[MembershipShortDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
