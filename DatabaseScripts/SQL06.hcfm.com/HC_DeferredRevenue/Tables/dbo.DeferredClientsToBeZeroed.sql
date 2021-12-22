CREATE TABLE [dbo].[DeferredClientsToBeZeroed](
	[CenterAndClient] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NEW] [float] NULL,
	[OLD] [float] NULL,
	[Variance] [float] NULL,
	[Description] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipKey] [float] NULL,
	[CenterSSID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientKey] [int] NULL,
	[DeferredRevenueHeaderKey] [int] NULL
) ON [PRIMARY]
