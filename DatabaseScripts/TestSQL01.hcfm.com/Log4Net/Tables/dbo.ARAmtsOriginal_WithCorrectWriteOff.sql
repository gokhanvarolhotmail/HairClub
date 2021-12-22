/* CreateDate: 11/07/2014 14:33:22.430 , ModifyDate: 11/07/2014 14:33:22.430 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARAmtsOriginal_WithCorrectWriteOff](
	[ClientGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewARBalance] [money] NULL,
	[TotalARCharges] [money] NULL,
	[TotalARCredits] [money] NULL,
	[CurrentARBalance] [money] NULL,
	[CurrentClientMembershipAccumAR] [money] NULL,
	[ActionTaken] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
