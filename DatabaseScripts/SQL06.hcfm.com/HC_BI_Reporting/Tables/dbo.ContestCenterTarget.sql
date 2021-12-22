/* CreateDate: 10/24/2013 09:54:51.727 , ModifyDate: 10/22/2018 23:10:03.620 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContestCenterTarget](
	[ContestCenterTargetSSID] [int] IDENTITY(1,1) NOT NULL,
	[ContestSSID] [int] NULL,
	[CenterSSID] [int] NOT NULL,
	[TargetRevenue] [money] NOT NULL,
	[TargetSales] [int] NULL,
	[TargetInitAppsCnt] [int] NULL,
	[TargetConversions] [int] NULL,
	[BIOConv] [int] NULL,
	[XtrConv] [int] NULL,
	[ExtConv] [int] NULL,
 CONSTRAINT [PK_ContestCenterTarget] PRIMARY KEY CLUSTERED
(
	[ContestCenterTargetSSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
