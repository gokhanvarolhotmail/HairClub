/* CreateDate: 04/07/2009 14:06:39.113 , ModifyDate: 04/07/2009 14:06:39.120 */
GO
CREATE TABLE [dbo].[cstd_dnc_verification_report](
	[SendDate] [datetime] NOT NULL,
	[TotalSent] [int] NULL,
	[TrueDNC] [int] NULL,
	[NoDNC] [int] NULL,
	[NonExistentNumbers] [int] NULL,
	[WirelessDNC] [int] NULL,
	[DNCPercent] [smallmoney] NULL
) ON [PRIMARY]
GO
