/* CreateDate: 11/10/2014 15:43:38.053 , ModifyDate: 11/10/2014 15:43:38.053 */
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
