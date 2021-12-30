/* CreateDate: 03/15/2016 15:31:28.277 , ModifyDate: 03/15/2016 15:31:28.447 */
GO
CREATE TABLE [dbo].[tmpEFTProfilesImport](
	[RowID] [int] NOT NULL,
	[CenterName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [int] NULL,
	[FirstName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipBeginDate] [datetime] NULL,
	[MembershipEndDate] [datetime] NULL,
	[MonthlyFee] [float] NULL,
	[ClientMembershipKey] [int] NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_tmpEFTProfilesImport] ON [dbo].[tmpEFTProfilesImport]
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
