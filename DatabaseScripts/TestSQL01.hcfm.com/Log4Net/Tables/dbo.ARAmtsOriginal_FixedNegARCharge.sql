/* CreateDate: 11/14/2014 16:46:09.240 , ModifyDate: 11/14/2014 16:46:09.240 */
GO
CREATE TABLE [dbo].[ARAmtsOriginal_FixedNegARCharge](
	[ClientGUID] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientARBalance] [money] NULL,
	[TotalARCharges] [money] NULL,
	[TotalARCredits] [money] NULL,
	[ClientMembershipAccumAR] [money] NULL,
	[ActionTaken] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LogCreateDate] [datetime] NULL,
	[TFSUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
