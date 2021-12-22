/* CreateDate: 02/21/2013 09:55:38.970 , ModifyDate: 02/21/2013 09:55:38.970 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MembershipRatesImport](
	[centerid] [float] NULL,
	[CenterName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Membership] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipAdditional] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FeeSequence] [float] NULL,
	[Rate] [float] NULL
) ON [PRIMARY]
GO
