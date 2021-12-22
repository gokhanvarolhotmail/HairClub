/* CreateDate: 10/31/2014 15:39:53.683 , ModifyDate: 10/31/2014 15:39:53.683 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARAmtsOriginal](
	[ClientGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewARBalance] [money] NULL,
	[TotalARCharges] [money] NULL,
	[TotalARCredits] [money] NULL,
	[CurrentARBalance] [money] NULL,
	[CurrentClientMembershipAccumAR] [money] NULL,
	[ActionTaken] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
