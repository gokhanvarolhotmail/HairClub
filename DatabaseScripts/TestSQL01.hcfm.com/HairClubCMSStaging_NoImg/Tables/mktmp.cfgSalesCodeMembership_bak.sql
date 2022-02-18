/* CreateDate: 12/30/2021 16:02:38.200 , ModifyDate: 02/07/2022 11:04:23.000 */
GO
CREATE TABLE [mktmp].[cfgSalesCodeMembership_bak](
	[SalesCodeMembershipID] [int] IDENTITY(1,1) NOT NULL,
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
	[IsFinancedToARFlag] [bit] NOT NULL
) ON [PRIMARY]
GO
