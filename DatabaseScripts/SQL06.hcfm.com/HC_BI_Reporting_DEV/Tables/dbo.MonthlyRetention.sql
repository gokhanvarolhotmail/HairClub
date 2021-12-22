/* CreateDate: 07/14/2016 17:17:01.633 , ModifyDate: 07/14/2016 17:17:01.633 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MonthlyRetention](
	[MonRetentionSSID] [int] IDENTITY(1,1) NOT NULL,
	[CenterSSID] [int] NULL,
	[Prev_XTRPlusPCPCount] [int] NULL,
	[Prev_XTRPlusPCPMaleCount] [int] NULL,
	[Prev_XTRPlusPCPFemaleCount] [int] NULL,
	[XTRPlusPCPCount] [int] NULL,
	[XTRPlusPCPMaleCount] [int] NULL,
	[XTRPlusPCPFemaleCount] [int] NULL,
	[Total_Conv] [int] NULL,
	[MaleNB_BIOConvCnt] [int] NULL,
	[FemaleNB_BIOConvCnt] [int] NULL,
	[Prev_FirstDateOfMonth] [datetime] NULL,
	[FirstDateOfMonth] [datetime] NULL,
	[PCPRetention] [decimal](18, 5) NULL,
	[MaleRetention] [decimal](18, 5) NULL,
	[FemaleRetention] [decimal](18, 5) NULL,
 CONSTRAINT [PK_MonthlyRetention] PRIMARY KEY CLUSTERED
(
	[MonRetentionSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
