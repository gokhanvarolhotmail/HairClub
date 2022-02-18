/* CreateDate: 01/11/2022 15:50:35.337 , ModifyDate: 02/07/2022 11:04:44.650 */
GO
CREATE TABLE [mktmp].[cfgSalesCodeMembership_bak_2](
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
