/* CreateDate: 06/08/2013 20:31:13.297 , ModifyDate: 06/08/2013 20:31:13.297 */
GO
CREATE TABLE [dbo].[FactDeferredRevenueHeader_06082013](
	[DeferredRevenueHeaderKey] [int] IDENTITY(1,1) NOT NULL,
	[DeferredRevenueTypeID] [int] NOT NULL,
	[CenterSSID] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[MembershipDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipRateKey] [int] NULL,
	[MonthsRemaining] [int] NULL,
	[Deferred] [money] NULL,
	[Revenue] [money] NULL,
	[DeferredToDate] [money] NULL,
	[RevenueToDate] [money] NULL,
	[TransferDeferredBalance] [bit] NULL,
	[DeferredBalanceTransferred] [money] NULL,
	[MembershipCancelled] [bit] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Client_No] [int] NULL,
	[Member1_ID] [int] NULL
) ON [PRIMARY]
GO
