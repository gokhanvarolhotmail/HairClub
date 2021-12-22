/* CreateDate: 12/03/2021 15:53:07.053 , ModifyDate: 12/03/2021 15:53:07.053 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactDeferredRevenueDetails_Copy211203](
	[DeferredRevenueHeaderKey] [int] NOT NULL,
	[DeferredRevenueDetailsKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Period] [datetime] NOT NULL,
	[Deferred] [money] NULL,
	[DeferredToDate] [money] NULL,
	[Revenue] [money] NULL,
	[RevenueToDate] [money] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Client_No] [int] NULL,
	[Member1_ID] [int] NULL,
	[CenterSSID] [int] NULL,
	[MonthsRemaining] [int] NULL
) ON [PRIMARY]
GO
