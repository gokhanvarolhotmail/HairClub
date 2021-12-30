/* CreateDate: 06/08/2013 20:31:06.087 , ModifyDate: 06/08/2013 20:31:06.087 */
GO
CREATE TABLE [dbo].[FactDeferredRevenueDetails_06082013](
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
