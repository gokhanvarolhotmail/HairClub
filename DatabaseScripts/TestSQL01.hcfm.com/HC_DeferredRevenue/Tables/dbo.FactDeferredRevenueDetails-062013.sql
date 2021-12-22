/* CreateDate: 06/04/2013 14:17:53.353 , ModifyDate: 06/04/2013 14:17:53.353 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactDeferredRevenueDetails-062013](
	[DeferredRevenueHeaderKey] [int] NOT NULL,
	[DeferredRevenueDetailsKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Period] [datetime] NOT NULL,
	[Deferred] [money] NULL,
	[Revenue] [money] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Client_No] [int] NULL,
	[Member1_ID] [int] NULL,
	[CenterSSID] [int] NULL
) ON [PRIMARY]
GO
