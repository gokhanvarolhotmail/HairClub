/* CreateDate: 03/15/2016 15:31:49.257 , ModifyDate: 06/24/2019 09:58:26.340 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tmpEFTProfilesImport](
	[RowID] [int] IDENTITY(1,1) NOT NULL,
	[CenterName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientIdentifier] [int] NULL,
	[FirstName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipBeginDate] [datetime] NULL,
	[MembershipEndDate] [datetime] NULL,
	[MonthlyFee] [float] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_tmpEFTProfilesImport] PRIMARY KEY CLUSTERED
(
	[RowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
