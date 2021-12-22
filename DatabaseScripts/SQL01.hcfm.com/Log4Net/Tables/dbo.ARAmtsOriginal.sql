/* CreateDate: 11/03/2014 15:18:05.840 , ModifyDate: 11/03/2014 15:18:05.840 */
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
