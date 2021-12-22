/* CreateDate: 12/06/2012 15:23:24.957 , ModifyDate: 03/03/2020 07:37:39.600 */
GO
CREATE TABLE [dbo].[DimMembershipRatesByCenter](
	[MembershipRateKey] [int] IDENTITY(1,1) NOT NULL,
	[CenterKey] [int] NOT NULL,
	[CenterSSID] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[MembershipDescription] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipRate] [money] NOT NULL,
	[RateStartDate] [datetime] NULL,
	[RateEndDate] [datetime] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateDate] [datetime] NULL,
	[UpdateUser] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimMembershipRatesByCenter_MembershipRateKey_INCL] ON [dbo].[DimMembershipRatesByCenter]
(
	[MembershipRateKey] ASC
)
INCLUDE([MembershipRate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_DimMembershipRatesByCenter_RateDates] ON [dbo].[DimMembershipRatesByCenter]
(
	[RateStartDate] ASC,
	[RateEndDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
