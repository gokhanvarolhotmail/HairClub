/* CreateDate: 02/21/2013 09:55:38.970 , ModifyDate: 09/02/2015 15:37:04.867 */
GO
CREATE TABLE [dbo].[MembershipRatesImport](
	[centerid] [float] NULL,
	[CenterName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipAdditional] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FeeSequence] [float] NULL,
	[Rate] [float] NULL,
	[MembershipShortDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
