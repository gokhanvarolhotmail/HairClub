/* CreateDate: 11/10/2014 16:34:53.980 , ModifyDate: 11/10/2014 16:34:53.980 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ARAmtsOriginal_WithDoubleTransWriteOff](
	[ClientGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewARBalance] [money] NULL,
	[TotalARCharges] [money] NULL,
	[TotalARCredits] [money] NULL,
	[CurrentARBalance] [money] NULL,
	[CurrentClientMembershipAccumAR] [money] NULL,
	[ActionTaken] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TFSUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LogCreateDate] [datetime] NULL
) ON [PRIMARY]
GO
