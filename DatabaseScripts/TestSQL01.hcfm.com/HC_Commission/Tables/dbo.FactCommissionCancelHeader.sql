/* CreateDate: 11/02/2012 11:24:57.053 , ModifyDate: 06/18/2014 01:38:27.757 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactCommissionCancelHeader](
	[CancelHeaderKey] [int] IDENTITY(1,1) NOT NULL,
	[CenterSSID] [int] NOT NULL,
	[SalesOrderKey] [int] NOT NULL,
	[SalesOrderDetailKey] [int] NOT NULL,
	[SalesOrderDate] [datetime] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateDate] [datetime] NOT NULL,
	[UpdateUser] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_FactCommissionCancelHeader] PRIMARY KEY CLUSTERED
(
	[CancelHeaderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
