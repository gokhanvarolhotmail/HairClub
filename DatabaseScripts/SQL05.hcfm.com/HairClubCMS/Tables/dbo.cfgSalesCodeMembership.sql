/* CreateDate: 05/05/2020 17:42:44.787 , ModifyDate: 06/01/2021 18:31:09.133 */
GO
CREATE TABLE [dbo].[cfgSalesCodeMembership](
	[SalesCodeMembershipID] [int] NOT NULL,
	[SalesCodeCenterID] [int] NULL,
	[MembershipID] [int] NULL,
	[Price] [money] NULL,
	[TaxRate1ID] [int] NULL,
	[TaxRate2ID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsFinancedToARFlag] [bit] NOT NULL,
 CONSTRAINT [PK_cfgSalesCodeMembership] PRIMARY KEY CLUSTERED
(
	[SalesCodeMembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeMembership_MembershipID_INCL] ON [dbo].[cfgSalesCodeMembership]
(
	[MembershipID] ASC
)
INCLUDE([SalesCodeCenterID],[TaxRate1ID],[TaxRate2ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
CREATE NONCLUSTERED INDEX [IX_cfgSalesCodeMembership_SalesCodeCenterID_INCL] ON [dbo].[cfgSalesCodeMembership]
(
	[SalesCodeCenterID] ASC,
	[MembershipID] ASC
)
INCLUDE([TaxRate1ID],[TaxRate2ID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
