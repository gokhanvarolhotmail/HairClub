/* CreateDate: 02/04/2022 13:44:00.740 , ModifyDate: 02/07/2022 11:18:46.583 */
GO
CREATE TABLE [mktmp].[tmp_cfgSalesCodeMembership_staging_Jul21](
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
	[UpdateStamp] [timestamp] NOT NULL,
	[IsFinancedToARFlag] [bit] NOT NULL
) ON [PRIMARY]
GO
