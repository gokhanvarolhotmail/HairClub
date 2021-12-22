/* CreateDate: 12/20/2021 16:37:19.903 , ModifyDate: 12/20/2021 16:37:19.903 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mktemp_DecPricingUpdates](
	[ClientGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NULL,
	[ClientIdentifier] [int] NULL,
	[MembershipID] [int] NULL,
	[ClientMembershipStatusID] [bit] NULL,
	[MonthlyFee] [money] NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[New Price] [money] NULL
) ON [FG1]
GO
