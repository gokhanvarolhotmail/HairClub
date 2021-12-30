/* CreateDate: 11/15/2006 11:39:37.763 , ModifyDate: 11/15/2006 11:39:37.763 */
GO
CREATE TABLE [dbo].[DNCVerificationReport](
	[SendDate] [datetime] NOT NULL,
	[TotalSent] [int] NULL,
	[TrueDNC] [int] NULL,
	[NoDNC] [int] NULL,
	[NonExistentNumbers] [int] NULL,
	[WirelessDNC] [int] NULL,
	[DNCPercent] [smallmoney] NULL
) ON [PRIMARY]
GO
