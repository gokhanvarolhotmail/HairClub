/* CreateDate: 05/31/2020 13:34:20.023 , ModifyDate: 05/31/2020 13:34:20.023 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpEFTProfilesImportTransitions](
	[CenterName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [float] NULL,
	[FirstName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipBeginDate] [datetime] NULL,
	[MembershipEndDate] [datetime] NULL,
	[MembershipStatus] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentMonthlyFee] [float] NULL,
	[PayCycle] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientMembershipIdentifier] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewMonthlyFee] [float] NULL
) ON [PRIMARY]
GO
